# Feature Plans & TODO

## CI/CD Pipeline for Google Play Internal Track Deployment

### Goal

Automate the release process so a single command deploys the latest code from master to Google Play's internal test track:
1. Auto-increment the build number
2. Build a signed Android app bundle
3. Upload to internal test track

### Approach

**GitHub Actions + `r0adkll/upload-google-play` action** (simpler than Fastlane for this use case)

#### How Build Number Auto-Increment Works

Use `--build-number` flag at build time with GitHub's run number:
```bash
flutter build appbundle --release --build-number=$(( github.run_number + OFFSET ))
```

This overrides the pubspec.yaml value without needing to commit changes back to the repo. Each workflow run gets a unique, incrementing number.

The offset ensures the new build number is higher than the current one (322). Set `BUILD_NUMBER_OFFSET=320` initially.

#### Workflow Trigger

Manual trigger (`workflow_dispatch`) - run with:
```bash
gh workflow run deploy-internal.yml
```

Or use the GitHub Actions web UI "Run workflow" button.

---

### Implementation Checklist

#### 1. Create GitHub Secrets

Add these in GitHub repo settings → Secrets and variables → Actions:

| Secret Name | Value |
|-------------|-------|
| `KEYSTORE_BASE64` | Base64-encoded keystore file |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_PASSWORD` | Key password |
| `KEY_ALIAS` | Key alias (`key`) |
| `PLAY_STORE_SERVICE_ACCOUNT_JSON` | Base64-encoded Google Play service account JSON |

**To encode files as base64 (macOS):**
```bash
base64 -i /path/to/key.jks | pbcopy  # copies to clipboard
base64 -i service-account.json | pbcopy
```

#### 2. Set Up Google Play Service Account (One-Time)

##### 2a. Create Google Cloud Project (if needed)
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project (or use existing one / Firebase project)

##### 2b. Enable the Google Play Developer API
1. Go to [Google Play Android Developer API](https://console.cloud.google.com/apis/library/androidpublisher.googleapis.com)
2. Select your project
3. Click **Enable**

##### 2c. Create Service Account
1. Go to [Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts)
2. Click **Create Service Account**
3. Enter a name (e.g., "GitHub Actions Deploy")
4. Click **Create and Continue**
5. Skip the role assignment (permissions set in Play Console)
6. Click **Done**

##### 2d. Download JSON Key
1. In the Service Accounts list, find your new account
2. Click the **⋮** menu → **Manage keys**
3. Click **Add key** → **Create new key**
4. Select **JSON** format
5. Click **Create** - file downloads automatically
6. Keep this file secure!

##### 2e. Grant Permissions in Google Play Console
1. Go to [Google Play Console](https://play.google.com/console) → **Users and permissions**
2. Click **Invite new users**
3. Enter the service account email (looks like `name@project.iam.gserviceaccount.com`)
4. Under **App permissions**, click **Add app** → select your app
5. Grant these permissions:
   - **Releases** → Manage production releases (or at minimum: Manage testing track releases)
6. Click **Invite user** → **Send invitation**

**Note**: Service account may take up to 24 hours to activate. To speed this up, make any small edit to a product/subscription in Play Console.

**Prerequisites**:
- App must already exist in Google Play Console
- At least one AAB/APK must have been manually uploaded before (API can't create the initial app listing)

#### 3. Create Workflow File

Create `.github/workflows/deploy-internal.yml`:

```yaml
name: Deploy to Internal Track

on:
  workflow_dispatch:
    inputs:
      version_name:
        description: 'Version name (e.g., 4.3.3) - leave empty to use pubspec.yaml'
        required: false
        type: string

env:
  FLUTTER_VERSION: "3.29.0"
  JAVA_VERSION: "17"
  BUILD_NUMBER_OFFSET: 320  # Adjust so build_number > current (322)

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: ${{ env.JAVA_VERSION }}

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Decode keystore
        run: echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/app/keystore.jks

      - name: Create key.properties
        run: |
          echo "storeFile=keystore.jks" > android/key.properties
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" >> android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties

      - name: Calculate build number
        id: build_number
        run: echo "value=$(( ${{ github.run_number }} + ${{ env.BUILD_NUMBER_OFFSET }} ))" >> $GITHUB_OUTPUT

      - name: Build App Bundle
        run: |
          BUILD_ARGS="--release --build-number=${{ steps.build_number.outputs.value }}"
          if [ -n "${{ inputs.version_name }}" ]; then
            BUILD_ARGS="$BUILD_ARGS --build-name=${{ inputs.version_name }}"
          fi
          flutter build appbundle $BUILD_ARGS

      - name: Decode service account
        run: echo "${{ secrets.PLAY_STORE_SERVICE_ACCOUNT_JSON }}" | base64 --decode > service-account.json

      - name: Upload to Play Store (Internal Track)
        uses: r0adkll/upload-google-play@v1.1.3
        with:
          serviceAccountJson: service-account.json
          packageName: tomkatcreative.gloomhavenenhancementcalc
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: internal
          status: completed
```

---

### Usage

After setup is complete:

```bash
# Deploy using current pubspec.yaml version
gh workflow run deploy-internal.yml

# Deploy with a specific version name
gh workflow run deploy-internal.yml -f version_name=4.3.3
```

Or use the GitHub Actions web UI → "Run workflow" button.

---

### Verification

1. Run the workflow manually from GitHub Actions
2. Check the workflow logs for successful build and upload
3. Go to Google Play Console → Internal testing → Releases
4. Verify new build appears with the correct version code

---

### Security Notes

- Keystore and service account JSON are stored as base64-encoded GitHub secrets
- Secrets are never logged or exposed in workflow output
- Sensitive files are created at runtime and not committed to the repo
