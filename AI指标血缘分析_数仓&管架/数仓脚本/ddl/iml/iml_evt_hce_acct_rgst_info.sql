/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_hce_acct_rgst_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_hce_acct_rgst_info
whenever sqlerror continue none;
drop table ${iml_schema}.evt_hce_acct_rgst_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_hce_acct_rgst_info(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,oper_tm timestamp -- 操作时间
    ,cust_id varchar2(100) -- 交易客户编号
    ,user_id varchar2(100) -- 用户编号
    ,user_name varchar2(150) -- 用户名称
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,mobile_no varchar2(60) -- 手机号码
    ,main_acct_id varchar2(100) -- 主账户编号
    ,appl_dt date -- 申请日期
    ,actv_dt date -- 激活日期
    ,cld_card_id varchar2(100) -- 云卡编号
    ,cld_card_invalid_dt date -- 云卡失效日期
    ,cld_card_status_cd varchar2(30) -- 云卡状态代码
    ,status_update_tm timestamp -- 状态更新时间
    ,main_acct_status_cd varchar2(30) -- 主账号状态代码
    ,iss_bank_lock_flg varchar2(10) -- 发卡行锁定标志
    ,card_holder_loss_flg varchar2(10) -- 持卡人挂失标志
    ,equip_model varchar2(100) -- 设备型号
    ,move_app_name varchar2(150) -- 移动应用名称
    ,beps_unpasew_flg varchar2(10) -- 小额免密标志
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_hce_acct_rgst_info to ${icl_schema};
grant select on ${iml_schema}.evt_hce_acct_rgst_info to ${idl_schema};
grant select on ${iml_schema}.evt_hce_acct_rgst_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_hce_acct_rgst_info is 'HCE账户登记信息';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.evt_id is '事件编号';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.lp_id is '法人编号';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.oper_tm is '操作时间';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.user_id is '用户编号';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.user_name is '用户名称';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.cert_no is '证件号码';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.mobile_no is '手机号码';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.main_acct_id is '主账户编号';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.actv_dt is '激活日期';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.cld_card_id is '云卡编号';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.cld_card_invalid_dt is '云卡失效日期';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.cld_card_status_cd is '云卡状态代码';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.status_update_tm is '状态更新时间';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.main_acct_status_cd is '主账号状态代码';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.iss_bank_lock_flg is '发卡行锁定标志';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.card_holder_loss_flg is '持卡人挂失标志';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.equip_model is '设备型号';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.move_app_name is '移动应用名称';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.beps_unpasew_flg is '小额免密标志';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.job_cd is '任务编码';
comment on column ${iml_schema}.evt_hce_acct_rgst_info.etl_timestamp is 'ETL处理时间戳';
