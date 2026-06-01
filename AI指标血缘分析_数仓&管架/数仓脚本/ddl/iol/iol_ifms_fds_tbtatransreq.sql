/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_fds_tbtatransreq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_fds_tbtatransreq
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_fds_tbtatransreq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_fds_tbtatransreq(
    trans_date number(22,0) -- 
    ,busin_code varchar2(9) -- 
    ,trans_time number(22,0) -- 
    ,serial_no varchar2(48) -- 
    ,seller_code varchar2(14) -- 
    ,branch_no varchar2(24) -- 
    ,asset_acc varchar2(30) -- 
    ,ta_client varchar2(30) -- 
    ,prd_code varchar2(30) -- 
    ,share_class varchar2(2) -- 
    ,amt number(18,2) -- 
    ,vol number(18,3) -- 
    ,tot_fee number(18,2) -- 
    ,targ_prd_code varchar2(30) -- 
    ,targ_share_class varchar2(2) -- 
    ,targ_asset_acc varchar2(30) -- 
    ,targ_ta_client varchar2(48) -- 
    ,targ_seller_code varchar2(14) -- 
    ,targ_net_no varchar2(48) -- 
    ,ori_cfm_date number(22,0) -- 
    ,ori_serial_no varchar2(48) -- 
    ,ori_cfm_no varchar2(36) -- 
    ,larg_red_flag varchar2(2) -- 
    ,hope_date number(22,0) -- 
    ,agio number(5,4) -- 
    ,div_mode varchar2(2) -- 
    ,frozen_cause varchar2(2) -- 
    ,frozen_end_date number(22,0) -- 
    ,frozen_law_no varchar2(36) -- 
    ,unfroze_law_no varchar2(36) -- 
    ,ta_flag varchar2(2) -- 
    ,out_busin_code varchar2(9) -- 
    ,man_flag varchar2(2) -- 
    ,client_type varchar2(2) -- 
    ,in_client_no varchar2(30) -- 
    ,last_cfm_date number(22,0) -- 
    ,status varchar2(2) -- 
    ,cfm_amt number(18,2) -- 
    ,cfm_vol number(18,3) -- 
    ,ori_agio number(5,4) -- 
    ,cfm_rate number(5,4) -- 
    ,rule_agio number(5,4) -- 
    ,broker varchar2(18) -- 
    ,nodeal_flag varchar2(2) -- 
    ,price number(18,8) -- 
    ,targ_price number(18,8) -- 
    ,ch_vol number(18,3) -- 
    ,channel varchar2(2) -- 
    ,transfer_cause varchar2(2) -- 
    ,first_cfm_date number(22,0) -- 
    ,income number(18,2) -- 
    ,back_agio number(5,4) -- 
    ,bank_no varchar2(14) -- 
    ,client_rate number(9,8) -- 
    ,client_group varchar2(2) -- 
    ,red_mode varchar2(2) -- 
    ,manager_agio number(5,4) -- 
    ,real_flag varchar2(2) -- 
    ,err_code varchar2(11) -- 
    ,err_msg varchar2(150) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(18,2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
    ,real_prd_code varchar2(30) -- 
    ,targ_real_prd_code varchar2(30) -- 
    ,client_manager varchar2(48) -- 
    ,ta_code varchar2(14) -- 
    ,client_risk number(22,0) -- 
    ,risk_date number(22,0) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifms_fds_tbtatransreq to ${iml_schema};
grant select on ${iol_schema}.ifms_fds_tbtatransreq to ${icl_schema};
grant select on ${iol_schema}.ifms_fds_tbtatransreq to ${idl_schema};
grant select on ${iol_schema}.ifms_fds_tbtatransreq to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_fds_tbtatransreq is '交易请求表';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.trans_date is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.busin_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.trans_time is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.serial_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.seller_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.branch_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.asset_acc is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.ta_client is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.prd_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.share_class is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.amt is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.vol is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.tot_fee is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.targ_prd_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.targ_share_class is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.targ_asset_acc is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.targ_ta_client is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.targ_seller_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.targ_net_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.ori_cfm_date is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.ori_serial_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.ori_cfm_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.larg_red_flag is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.hope_date is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.agio is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.div_mode is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.frozen_cause is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.frozen_end_date is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.frozen_law_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.unfroze_law_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.ta_flag is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.out_busin_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.man_flag is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.client_type is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.in_client_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.last_cfm_date is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.status is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.cfm_amt is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.cfm_vol is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.ori_agio is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.cfm_rate is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.rule_agio is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.broker is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.nodeal_flag is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.price is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.targ_price is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.ch_vol is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.channel is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.transfer_cause is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.first_cfm_date is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.income is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.back_agio is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.bank_no is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.client_rate is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.client_group is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.red_mode is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.manager_agio is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.real_flag is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.err_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.err_msg is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.amt1 is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.amt2 is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.reserve1 is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.reserve2 is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.reserve3 is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.reserve4 is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.reserve5 is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.real_prd_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.targ_real_prd_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.client_manager is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.ta_code is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.client_risk is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.risk_date is '';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_fds_tbtatransreq.etl_timestamp is 'ETL处理时间戳';
