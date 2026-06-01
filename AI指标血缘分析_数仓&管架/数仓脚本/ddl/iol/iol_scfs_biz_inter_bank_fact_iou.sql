/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scfs_biz_inter_bank_fact_iou
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scfs_biz_inter_bank_fact_iou
whenever sqlerror continue none;
drop table ${iol_schema}.scfs_biz_inter_bank_fact_iou purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scfs_biz_inter_bank_fact_iou(
    id number(6) -- 主键id
    ,bank_fact_id varchar2(32) -- 跨行再保理编号
    ,fnc_jrnl_id varchar2(32) -- 融资申请编号
    ,iou_id varchar2(32) -- 借据号
    ,pd_id varchar2(32) -- 产品编号
    ,pd_nm varchar2(200) -- 产品名称
    ,cst_id varchar2(32) -- 客户编号
    ,cst_nm varchar2(200) -- 客户名称
    ,ths_fnc_amt number(20,6) -- 融资金额
    ,fnc_bg_dt date -- 融资起始日期
    ,fnc_ex_dt date -- 融资结束日期
    ,st_cd varchar2(10) -- 生效状态
    ,tenant_id varchar2(32) -- 租户id
    ,create_time date -- 创建时间
    ,create_user varchar2(32) -- 创建人
    ,update_time date -- 更新时间
    ,update_user varchar2(32) -- 更新人
    ,version number(10) -- 版本号
    ,del_ind varchar2(1) -- 删除标志
    ,iou_bay_out_net_amt number(20,6) -- 转让净价
    ,iou_sell_interest number(20,6) -- 卖出利息
    ,iou_fee_amt number(20,6) -- 卖出手续费
    ,iou_exchange_amt number(20,6) -- 转让对价
    ,iou_sell_org varchar2(300) -- 卖出机构
    ,expd_id varchar2(32) -- 扩展编号
    ,fnc_dt date -- 融资日期
    ,maturity date -- 融资到期日
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
grant select on ${iol_schema}.scfs_biz_inter_bank_fact_iou to ${iml_schema};
grant select on ${iol_schema}.scfs_biz_inter_bank_fact_iou to ${icl_schema};
grant select on ${iol_schema}.scfs_biz_inter_bank_fact_iou to ${idl_schema};
grant select on ${iol_schema}.scfs_biz_inter_bank_fact_iou to ${iel_schema};

-- comment
comment on table ${iol_schema}.scfs_biz_inter_bank_fact_iou is '跨行再保理信息借据关联表';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.id is '主键id';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.bank_fact_id is '跨行再保理编号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.fnc_jrnl_id is '融资申请编号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.iou_id is '借据号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.pd_id is '产品编号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.pd_nm is '产品名称';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.cst_id is '客户编号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.cst_nm is '客户名称';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.ths_fnc_amt is '融资金额';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.fnc_bg_dt is '融资起始日期';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.fnc_ex_dt is '融资结束日期';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.st_cd is '生效状态';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.tenant_id is '租户id';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.create_time is '创建时间';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.create_user is '创建人';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.update_time is '更新时间';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.update_user is '更新人';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.version is '版本号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.del_ind is '删除标志';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.iou_bay_out_net_amt is '转让净价';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.iou_sell_interest is '卖出利息';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.iou_fee_amt is '卖出手续费';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.iou_exchange_amt is '转让对价';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.iou_sell_org is '卖出机构';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.expd_id is '扩展编号';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.fnc_dt is '融资日期';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.maturity is '融资到期日';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.start_dt is '开始时间';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.end_dt is '结束时间';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.id_mark is '增删标志';
comment on column ${iol_schema}.scfs_biz_inter_bank_fact_iou.etl_timestamp is 'ETL处理时间戳';
