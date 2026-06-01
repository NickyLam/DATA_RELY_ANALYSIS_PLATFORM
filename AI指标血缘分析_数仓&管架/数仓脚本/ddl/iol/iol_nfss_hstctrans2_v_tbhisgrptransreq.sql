/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_hstctrans2_v_tbhisgrptransreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq(
    serial_no varchar2(48) -- 
    ,ex_serial varchar2(48) -- 
    ,contract_no varchar2(48) -- 
    ,trans_date number(22,0) -- 
    ,trans_time number(22,0) -- 
    ,occur_init_date number(22,0) -- 
    ,in_client_no varchar2(30) -- 
    ,virtual_bank_acc varchar2(48) -- 
    ,trans_code varchar2(48) -- 
    ,control_flag varchar2(768) -- 
    ,branch_no varchar2(24) -- 
    ,open_branch varchar2(120) -- 
    ,client_type varchar2(2) -- 
    ,id_type varchar2(5) -- 
    ,id_code varchar2(75) -- 
    ,bank_no varchar2(48) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(96) -- 
    ,cash_flag varchar2(2) -- 
    ,trans_account_type varchar2(2) -- 
    ,trans_account varchar2(48) -- 
    ,channel varchar2(2) -- 
    ,term_no varchar2(24) -- 
    ,oper_no varchar2(48) -- 
    ,auth_oper varchar2(48) -- 
    ,group_code varchar2(48) -- 
    ,asso_date number(22,0) -- 
    ,asso_serial varchar2(48) -- 
    ,asso_serial2 varchar2(48) -- 
    ,asso_serial3 varchar2(48) -- 
    ,amt number(18,2) -- 
    ,ori_channel varchar2(2) -- 
    ,ori_branch_no varchar2(24) -- 
    ,larg_red_flag varchar2(2) -- 
    ,to_lcpt_serial varchar2(48) -- 
    ,lcpt_check_date number(22,0) -- 
    ,lcpt_trans_code varchar2(9) -- 
    ,lcpt_date number(22,0) -- 
    ,lcpt_serial varchar2(48) -- 
    ,to_host_serial varchar2(48) -- 
    ,host_check_date number(22,0) -- 
    ,ori_host_chk_date number(22,0) -- 
    ,host_trans_code varchar2(9) -- 
    ,host_date number(22,0) -- 
    ,host_serial varchar2(48) -- 
    ,liqu_status varchar2(2) -- 
    ,client_manager varchar2(48) -- 
    ,targ_bank_acc varchar2(48) -- 
    ,err_code varchar2(18) -- 
    ,err_msg varchar2(768) -- 
    ,status varchar2(2) -- 
    ,summary varchar2(375) -- 
    ,debit_account varchar2(48) -- 
    ,crebit_account varchar2(48) -- 
    ,phy_date number(22,0) -- 
    ,model varchar2(2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(18,2) -- 
    ,amt3 number(18,2) -- 
    ,amt4 number(18,2) -- 
    ,amt5 number(18,2) -- 
    ,amt6 number(18,2) -- 
    ,double1 number(22,8) -- 
    ,double2 number(22,8) -- 
    ,double3 number(22,8) -- 
    ,double4 number(22,8) -- 
    ,double5 number(22,8) -- 
    ,reserve6 varchar2(768) -- 
    ,reserve7 varchar2(375) -- 
    ,reserve8 varchar2(375) -- 
    ,redem_account varchar2(48) -- 
    ,child_prd_codes varchar2(600) -- 
    ,child_prd_rates varchar2(600) -- 
    ,child_new_prd_rates varchar2(600) -- 
    ,modify_timestamp number(14,0) -- 
    ,client_name varchar2(375) -- 
    ,mobile varchar2(60) -- 
    ,cfm_amt number(18,2) -- 
    ,cfm_date number(22,0) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq to ${iml_schema};
grant select on ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq to ${icl_schema};
grant select on ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq to ${idl_schema};
grant select on ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq is '历史交易主流水表';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.serial_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.ex_serial is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.contract_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.trans_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.trans_time is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.occur_init_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.in_client_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.virtual_bank_acc is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.trans_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.control_flag is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.branch_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.open_branch is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.client_type is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.id_type is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.id_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.bank_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.client_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.bank_acc is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.cash_flag is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.trans_account_type is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.trans_account is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.channel is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.term_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.oper_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.auth_oper is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.group_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.asso_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.asso_serial is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.asso_serial2 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.asso_serial3 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.amt is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.ori_channel is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.ori_branch_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.larg_red_flag is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.to_lcpt_serial is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.lcpt_check_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.lcpt_trans_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.lcpt_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.lcpt_serial is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.to_host_serial is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.host_check_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.ori_host_chk_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.host_trans_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.host_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.host_serial is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.liqu_status is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.client_manager is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.targ_bank_acc is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.err_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.err_msg is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.status is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.summary is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.debit_account is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.crebit_account is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.phy_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.model is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.reserve1 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.reserve2 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.reserve3 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.reserve4 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.reserve5 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.amt1 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.amt2 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.amt3 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.amt4 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.amt5 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.amt6 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.double1 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.double2 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.double3 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.double4 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.double5 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.reserve6 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.reserve7 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.reserve8 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.redem_account is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.child_prd_codes is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.child_prd_rates is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.child_new_prd_rates is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.modify_timestamp is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.client_name is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.mobile is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.cfm_amt is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.cfm_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrptransreq.etl_timestamp is 'ETL处理时间戳';
