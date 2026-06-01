: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pbss_acs_t_rpa_acct_record_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pbss_acs_t_rpa_acct_record.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,id
    ,scan_seq_no
    ,create_time
    ,start_time
    ,end_time
    ,people_fail_reason
    ,query_type
    ,ilegal_relat_company
    ,ilegal_relat_acctno
    ,ilegal_phone_relat_acctno
    ,oprerator_relat_acctno
    ,oprerator_phone_relat_acctno
    ,similar_relat_acctno
    ,similar_addr_relat_company
    ,is_hanging_acctno
    ,rec_type
    ,people_bank_rpa_result
    ,guangdong_company_rpa_result
    ,guangdong_company_fail_reason
    ,des_file_name
    ,sdi_file_path
    ,gd_start_time
    ,gd_end_time
    ,people_bank_query_rpa_result
    ,people_bank_query_rpa_fr
    ,guangdong_record_rpa_result
    ,guangdong_record_rpa_fr
    ,sz_image_result
    ,sz_image_fail_reason
    ,sz_start_time
    ,sz_end_time
    ,is_flag
    ,pw_file_name
    ,pw_file_path
    ,op_account_num
    ,gd_notsz_flag
    ,old_open_licen
    ,sz_is_have_id
    ,arcid
    ,pboc
    ,ebank
    ,iselsewhere
    ,cust_name
    ,deposit_type
    ,telephone
    ,compay_fin_type
    ,principal_name
    ,principal_papers_type
    ,principal_papers_number
    ,district_code
    ,register_curr_type
    ,registerfund
    ,compay_organiz_code
    ,papers_type
    ,papers_number
    ,papers_type2
    ,papers_number2
    ,nat_register_no
    ,local_register_no
    ,contact_address
    ,operate_scope
    ,torpa_compay_oragniz_code
    ,organiz_code
    ,papers_kind
    ,papers_id
    ,approveno
    ,distinctcode
    ,brcode
    ,imagename
    ,filepath
    ,cust_name_eb
    ,papers_number_eb
    ,principal_name_eb
    ,principal_papers_type_eb
    ,principal_papers_number_eb
    ,phone_eb
    ,contact_address_eb
    ,proxy_name_eb
    ,proxy_papers_type_eb
    ,proxy_papers_number_eb
    ,proxy_phone_eb
    ,uuid
    ,isorganizpaper
    ,papers_contact_address
    ,papers_principal_name
    ,papers_papers_number
    ,papers_cust_name
    ,papers_registerfund
    ,papers_operate_scope
    ,torpa_nat_register_no
    ,torpa_local_register_no
    ,is_need_eluton_inchange
    ,torpa_scope
    ,torpa_found_date
    ,torpa_call_phone
    ,papers_type_eb
    ,registerfund_eb
    ,istoscope_pb
    ,deposit_type_eb
    ,acct_opendt_eb
    ,trade_type_eb
    ,found_date_eb
    ,perpers_invaldt_eb
    ,principal_invaldt_eb
    ,acct_name_eb
    ,rpa_people_count
    ,rpa_manual_record
    ,rpa_max_count
    ,ecfi_papers_t
    ,start_dt
    ,end_dt
    ,id_mark
from idl.pbss_acs_t_rpa_acct_record 
  where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbss_acs_t_rpa_acct_record.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes