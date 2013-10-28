#!/bin/sh -e

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

(test -f $srcdir/libsignon-glib.pc.in ) || {
	echo -n "Error: Directory "\`$srcdir\`" does not look like the "
        echo "top-level libsignon-glib directory."
	exit 1
}

# check if gtk-doc is explicitly disabled
for ag_option in $@
do
   case $ag_option in
       -disable-gtk-doc | --disable-gtk-doc)
       enable_gtk_doc=no
   ;;
   esac
done

if test x$enable_gtk_doc = xno; then
    if test -f gtk-doc.make; then :; else
        echo "EXTRA_DIST = missing-gtk-doc" > gtk-doc.make
    fi
    echo "WARNING: You have disabled gtk-doc."
    echo "         As a result, you will not be able to generate the API"
    echo "         documentation and 'make dist' will not work."
    echo
else
    echo 'Running gtkdocize'
    cd "$srcdir"
    gtkdocize --copy --flavour no-tmpl || exit $?
fi

cd "$OLDPWD"
autoreconf --install --force --verbose --warnings=all "$srcdir"
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"
