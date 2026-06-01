/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_dpst_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_dpst_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_dpst_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_dpst_info(
    id varchar2(60) -- ID
    ,rs_product varchar2(14) -- 存托应答方存托类产品
    ,rs_product_name varchar2(384) -- 存托产品名称
    ,req_org_code varchar2(15) -- 存托机构代码
    ,std_product_code varchar2(14) -- 标准化票据产品代码
    ,std_product_bank_no varchar2(18) -- 标准化票据产品开户行行号
    ,std_product_bank_name varchar2(270) -- 标准化票据产品开户行名称
    ,sum_draft_amount number(18,2) -- 存托票据汇总金额
    ,settle_amount number(18,2) -- 存托结算金额
    ,dpst_result varchar2(2) -- 创设结果： 0 创设中 1 创设成功 2 创设失败
    ,branch_no varchar2(15) -- 业务机构号
    ,top_branch_no varchar2(15) -- 总行机构号
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,reserve1 varchar2(384) -- 备用字段1
    ,reserve2 varchar2(384) -- 备用字段2
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
grant select on ${iol_schema}.bdms_cpes_dpst_info to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_info to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_info to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_dpst_info is '存托产品信息表';
comment on column ${iol_schema}.bdms_cpes_dpst_info.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_dpst_info.rs_product is '存托应答方存托类产品';
comment on column ${iol_schema}.bdms_cpes_dpst_info.rs_product_name is '存托产品名称';
comment on column ${iol_schema}.bdms_cpes_dpst_info.req_org_code is '存托机构代码';
comment on column ${iol_schema}.bdms_cpes_dpst_info.std_product_code is '标准化票据产品代码';
comment on column ${iol_schema}.bdms_cpes_dpst_info.std_product_bank_no is '标准化票据产品开户行行号';
comment on column ${iol_schema}.bdms_cpes_dpst_info.std_product_bank_name is '标准化票据产品开户行名称';
comment on column ${iol_schema}.bdms_cpes_dpst_info.sum_draft_amount is '存托票据汇总金额';
comment on column ${iol_schema}.bdms_cpes_dpst_info.settle_amount is '存托结算金额';
comment on column ${iol_schema}.bdms_cpes_dpst_info.dpst_result is '创设结果： 0 创设中 1 创设成功 2 创设失败';
comment on column ${iol_schema}.bdms_cpes_dpst_info.branch_no is '业务机构号';
comment on column ${iol_schema}.bdms_cpes_dpst_info.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_dpst_info.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_dpst_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_dpst_info.reserve1 is '备用字段1';
comment on column ${iol_schema}.bdms_cpes_dpst_info.reserve2 is '备用字段2';
comment on column ${iol_schema}.bdms_cpes_dpst_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_dpst_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_dpst_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_dpst_info.etl_timestamp is 'ETL处理时间戳';
