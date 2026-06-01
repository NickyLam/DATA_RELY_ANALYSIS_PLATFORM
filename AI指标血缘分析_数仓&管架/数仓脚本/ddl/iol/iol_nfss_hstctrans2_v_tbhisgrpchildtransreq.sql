/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_hstctrans2_v_tbhisgrpchildtransreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq(
    serial_no varchar2(48) -- 
    ,ex_serial varchar2(48) -- 
    ,model varchar2(2) -- 
    ,trans_code varchar2(48) -- 
    ,group_code varchar2(48) -- 
    ,prd_type varchar2(2) -- 
    ,trans_date number(22,0) -- 
    ,trans_time number(22,0) -- 
    ,child_serial_no varchar2(48) -- 
    ,sub_trans_code varchar2(48) -- 
    ,prd_code varchar2(48) -- 
    ,amt number(18,2) -- 
    ,vol number(18,3) -- 
    ,cfm_vol number(18,3) -- 
    ,cfm_amt number(18,2) -- 
    ,fee number(18,2) -- 
    ,err_code varchar2(18) -- 
    ,err_msg varchar2(768) -- 
    ,child_status varchar2(2) -- 
    ,summary varchar2(375) -- 
    ,to_host_serial varchar2(48) -- 
    ,check_date number(22,0) -- 
    ,ori_host_chk_date number(22,0) -- 
    ,host_trans_code varchar2(9) -- 
    ,host_date number(22,0) -- 
    ,host_serial varchar2(48) -- 
    ,liqu_status varchar2(2) -- 
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
    ,cancel_date number(22,0) -- 
    ,cancel_time number(22,0) -- 
    ,cfm_fee number(18,2) -- 
    ,cfm_nav number(18,8) -- 
    ,double1 number(22,8) -- 
    ,double2 number(22,8) -- 
    ,double3 number(22,8) -- 
    ,double4 number(22,8) -- 
    ,double5 number(22,8) -- 
    ,asso_serial varchar2(48) -- 
    ,asso_serial2 varchar2(48) -- 
    ,asso_serial3 varchar2(48) -- 
    ,agio number(5,4) -- 
    ,square_date number(22,0) -- 
    ,in_client_no varchar2(30) -- 
    ,phy_date number(22,0) -- 
    ,modify_timestamp number(14,0) -- 
    ,cancel_amt number(18,2) -- 
    ,cfm_date number(22,0) -- 
    ,client_manager varchar2(48) -- 
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
grant select on ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq to ${iml_schema};
grant select on ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq to ${icl_schema};
grant select on ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq to ${idl_schema};
grant select on ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq is '历史交易子流水表';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.serial_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.ex_serial is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.model is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.trans_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.group_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.prd_type is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.trans_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.trans_time is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.child_serial_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.sub_trans_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.prd_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.amt is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.vol is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.cfm_vol is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.cfm_amt is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.fee is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.err_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.err_msg is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.child_status is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.summary is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.to_host_serial is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.check_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.ori_host_chk_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.host_trans_code is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.host_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.host_serial is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.liqu_status is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.reserve1 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.reserve2 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.reserve3 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.reserve4 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.reserve5 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.amt1 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.amt2 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.amt3 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.amt4 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.amt5 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.amt6 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.cancel_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.cancel_time is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.cfm_fee is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.cfm_nav is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.double1 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.double2 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.double3 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.double4 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.double5 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.asso_serial is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.asso_serial2 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.asso_serial3 is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.agio is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.square_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.in_client_no is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.phy_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.modify_timestamp is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.cancel_amt is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.cfm_date is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.client_manager is '';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq.etl_timestamp is 'ETL处理时间戳';
