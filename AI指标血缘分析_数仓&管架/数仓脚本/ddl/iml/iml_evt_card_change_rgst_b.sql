/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_card_change_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_card_change_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_card_change_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_card_change_rgst_b(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_dt date -- 申请日期
    ,init_card_no varchar2(60) -- 原卡号
    ,tran_dt date -- 交易日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,change_rs_cd varchar2(30) -- 更换原因代码
    ,modif_type_status_cd varchar2(30) -- 变更类型状态代码
    ,apot_draw_card_dt date -- 约定领卡日期
    ,card_prod_id varchar2(100) -- 卡产品编号
    ,new_card_num varchar2(60) -- 新卡号
    ,cust_id varchar2(100) -- 客户编号
    ,draw_way_cd varchar2(30) -- 领取方式代码
    ,save_num_change_card_flg varchar2(10) -- 同号换卡标志
    ,urgent_flg varchar2(10) -- 加急标志
    ,loss_id varchar2(100) -- 挂失编号
    ,cust_addr varchar2(500) -- 客户地址
    ,zip_code varchar2(60) -- 邮政编码
    ,remark varchar2(500) -- 备注
    ,tel_num varchar2(60) -- 电话号码
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,appl_teller_id varchar2(100) -- 申请柜员编号
    ,tran_tm timestamp -- 交易时间
    ,cust_acct_num varchar2(60) -- 客户账号
    ,aldy_proc_flg varchar2(10) -- 已处理标志
    ,charge_tran_ref_no varchar2(60) -- 收费交易参考号
    ,exper_odd_no varchar2(60) -- 快递单号
    ,appl_id varchar2(100) -- 申请编号
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
grant select on ${iml_schema}.evt_card_change_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_card_change_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_card_change_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_card_change_rgst_b is '卡片更换登记簿';
comment on column ${iml_schema}.evt_card_change_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_card_change_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_card_change_rgst_b.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_card_change_rgst_b.init_card_no is '原卡号';
comment on column ${iml_schema}.evt_card_change_rgst_b.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_card_change_rgst_b.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_card_change_rgst_b.change_rs_cd is '更换原因代码';
comment on column ${iml_schema}.evt_card_change_rgst_b.modif_type_status_cd is '变更类型状态代码';
comment on column ${iml_schema}.evt_card_change_rgst_b.apot_draw_card_dt is '约定领卡日期';
comment on column ${iml_schema}.evt_card_change_rgst_b.card_prod_id is '卡产品编号';
comment on column ${iml_schema}.evt_card_change_rgst_b.new_card_num is '新卡号';
comment on column ${iml_schema}.evt_card_change_rgst_b.cust_id is '客户编号';
comment on column ${iml_schema}.evt_card_change_rgst_b.draw_way_cd is '领取方式代码';
comment on column ${iml_schema}.evt_card_change_rgst_b.save_num_change_card_flg is '同号换卡标志';
comment on column ${iml_schema}.evt_card_change_rgst_b.urgent_flg is '加急标志';
comment on column ${iml_schema}.evt_card_change_rgst_b.loss_id is '挂失编号';
comment on column ${iml_schema}.evt_card_change_rgst_b.cust_addr is '客户地址';
comment on column ${iml_schema}.evt_card_change_rgst_b.zip_code is '邮政编码';
comment on column ${iml_schema}.evt_card_change_rgst_b.remark is '备注';
comment on column ${iml_schema}.evt_card_change_rgst_b.tel_num is '电话号码';
comment on column ${iml_schema}.evt_card_change_rgst_b.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_card_change_rgst_b.appl_teller_id is '申请柜员编号';
comment on column ${iml_schema}.evt_card_change_rgst_b.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_card_change_rgst_b.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_card_change_rgst_b.aldy_proc_flg is '已处理标志';
comment on column ${iml_schema}.evt_card_change_rgst_b.charge_tran_ref_no is '收费交易参考号';
comment on column ${iml_schema}.evt_card_change_rgst_b.exper_odd_no is '快递单号';
comment on column ${iml_schema}.evt_card_change_rgst_b.appl_id is '申请编号';
comment on column ${iml_schema}.evt_card_change_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_card_change_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_card_change_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_card_change_rgst_b.etl_timestamp is 'ETL处理时间戳';
