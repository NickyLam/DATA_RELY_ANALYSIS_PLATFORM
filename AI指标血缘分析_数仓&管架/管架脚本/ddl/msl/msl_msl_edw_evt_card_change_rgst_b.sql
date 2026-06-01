/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_evt_card_change_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_evt_card_change_rgst_b
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_evt_card_change_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_evt_card_change_rgst_b(
    etl_dt date
    ,evt_id varchar2(250)
    ,lp_id varchar2(100)
    ,appl_dt date
    ,init_card_no varchar2(60)
    ,tran_dt date
    ,tran_org_id varchar2(100)
    ,change_rs_cd varchar2(30)
    ,modif_type_status_cd varchar2(30)
    ,apot_draw_card_dt date
    ,card_prod_id varchar2(100)
    ,new_card_num varchar2(60)
    ,cust_id varchar2(100)
    ,draw_way_cd varchar2(30)
    ,save_num_change_card_flg varchar2(10)
    ,urgent_flg varchar2(10)
    ,loss_id varchar2(100)
    ,cust_addr varchar2(500)
    ,zip_code varchar2(60)
    ,remark varchar2(500)
    ,tel_num varchar2(60)
    ,tran_teller_id varchar2(100)
    ,appl_teller_id varchar2(100)
    ,tran_tm timestamp
    ,cust_acct_num varchar2(60)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_evt_card_change_rgst_b to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_evt_card_change_rgst_b is '卡片更换登记簿';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.evt_id is '事件编号';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.appl_dt is '申请日期';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.init_card_no is '原卡号';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.tran_dt is '交易日期';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.tran_org_id is '交易机构编号';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.change_rs_cd is '更换原因代码';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.modif_type_status_cd is '变更类型状态代码';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.apot_draw_card_dt is '约定领卡日期';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.card_prod_id is '卡产品编号';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.new_card_num is '新卡号';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.cust_id is '客户编号';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.draw_way_cd is '领取方式代码';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.save_num_change_card_flg is '同号换卡标志';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.urgent_flg is '加急标志';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.loss_id is '挂失编号';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.cust_addr is '客户地址';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.zip_code is '邮政编码';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.remark is '备注';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.tel_num is '电话号码';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.tran_teller_id is '交易柜员编号';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.appl_teller_id is '申请柜员编号';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.tran_tm is '交易时间';
comment on column ${msl_schema}.msl_edw_evt_card_change_rgst_b.cust_acct_num is '客户账号';
