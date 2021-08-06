/// Content of the value key passed in as the parent
const PARENT_KEY = "Value used to create the parent key. Don't use the same value key as parent. 1234567890";

/// This is a random constant value that represents matchParent in android.
/// This workaround makes it possible for us to just pass "matchParent" where dart compiler expects a double value.
///
/// [matchParent] is negative, therefore, it is a normally invalid size value.
/// This makes sure that it doesn't interfere with any valid size value.
///
/// [matchParent]'s value is intentionally complicated to prevent accidental assignments.
///
/// When the [ConstraintLayout] sees this value passed in as size (width or height), it behaves accordingly.
const double matchParent = -31415926535.8979323846;

/// This is a random constant value that represents wrapContent in android.
/// This workaround makes it possible for us to just pass "wrapContent" where dart compiler expects a double value.
///
/// [wrapContent] is negative, therefore, it is a normally invalid size value.
/// This makes sure that it doesn't interfere with any valid size value.
///
/// [wrapContent]'s value is intentionally complicated to prevent accidental assignments.
///
/// When the [ConstraintLayout] sees this value passed in as size (width or height), it behaves accordingly.
const double wrapContent = -2718281828.4590452353;