data "oci_objectstorage_namespace" "objectstorage_namespace" {
    #Optional
    compartment_id = "${var.compartment_ocid}"
}

resource "oci_objectstorage_preauthrequest" "obico_backup_preauthenticated_request" {
    #Required
    access_type = "AnyObjectReadWrite"
    bucket = "${var.bucket_name}"
    name = "tds_backup"
    namespace = "${data.oci_objectstorage_namespace.objectstorage_namespace.namespace}"
    time_expires = "2050-12-31T00:00:00Z"

}
