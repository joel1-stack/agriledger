#!/bin/bash
# Complete Agri-Ledger Deployment Script
# Run this to deploy the entire unified approval system

echo "🚀 Starting Agri-Ledger Complete System Deployment..."
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# Step 1: Backup existing files
# ═══════════════════════════════════════════════════════════════════════════

echo "📦 Step 1: Backing up existing files..."
cp firestore.rules firestore.rules.backup
cp firestore.indexes.json firestore.indexes.json.backup
echo "✅ Backups created"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# Step 2: Update Firestore Rules
# ═══════════════════════════════════════════════════════════════════════════

echo "🔐 Step 2: Deploying Firestore Rules..."
echo "   (Copy content from firestore_rules_complete.txt to firestore.rules)"
echo "   Manual: Open firestore.rules and replace with firestore_rules_complete.txt"
echo ""
# Alternatively, if you have permissions:
# cp firestore_rules_complete.txt firestore.rules

# ═══════════════════════════════════════════════════════════════════════════
# Step 3: Update Firestore Indexes
# ═══════════════════════════════════════════════════════════════════════════

echo "📊 Step 3: Adding Firestore Indexes..."
echo "   (Update firestore.indexes.json with composite indexes)"
echo "   See COMPLETE_SYSTEM_README.md for index definitions"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# Step 4: Deploy to Firebase
# ═══════════════════════════════════════════════════════════════════════════

echo "☁️  Step 4: Deploying to Firebase..."

echo ""
echo "   4a. Deploy Firestore Rules..."
firebase deploy --only firestore:rules

echo ""
echo "   4b. Deploy Firestore Indexes..."
firebase deploy --only firestore:indexes

echo ""
echo "   4c. Update Cloud Functions..."
echo "       → Copy functions/index_complete.js → functions/index.js"
echo "       → Run: cd functions && npm install"
echo "       → Run: firebase deploy --only functions"
echo ""
read -p "   Press Enter when you've updated Cloud Functions and deployed them..."

# ═══════════════════════════════════════════════════════════════════════════
# Step 5: Flutter Setup
# ═══════════════════════════════════════════════════════════════════════════

echo ""
echo "📱 Step 5: Setting up Flutter..."
echo ""
echo "   Running: flutter pub get"
flutter pub get

echo ""
echo "✅ All Flutter dependencies updated"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# Step 6: Verification
# ═══════════════════════════════════════════════════════════════════════════

echo "🔍 Step 6: Verification Checklist"
echo ""
echo "   ✓ Firestore rules deployed? (firebase deploy --only firestore:rules)"
echo "   ✓ Firestore indexes deployed? (firebase deploy --only firestore:indexes)"
echo "   ✓ Cloud functions deployed? (firebase deploy --only functions)"
echo "   ✓ Flutter dependencies updated? (flutter pub get)"
echo ""
echo "   Run Cloud Functions Log Check:"
echo "   → firebase functions:log"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# Step 7: Run App
# ═══════════════════════════════════════════════════════════════════════════

echo "🎉 Deployment Complete!"
echo ""
echo "📱 To run the app:"
echo "   flutter run -d <device_id>"
echo ""
echo "🧪 To test:"
echo "   1. Worker submits feed record"
echo "   2. Manager opens approval queue (should see pending)"
echo "   3. Manager approves → Worker gets notification"
echo "   4. Check audit logs in Firestore"
echo ""

