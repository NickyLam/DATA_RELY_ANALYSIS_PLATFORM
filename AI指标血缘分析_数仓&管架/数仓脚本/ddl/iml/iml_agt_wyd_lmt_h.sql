/*
Purpose:    整合模型层-切片建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wyd_lmt_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wyd_lmt_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wyd_lmt_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_lmt_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,lmt_id varchar2(100) -- 额度编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(100) -- 证件号码
    ,curr_cd varchar2(30) -- 币种代码
    ,prod_id varchar2(100) -- 产品编号
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,org_id varchar2(100) -- 机构编号
    ,circl_lmt_flg varchar2(10) -- 循环额度标志
    ,crdt_id varchar2(100) -- 授信编号
    ,crdt_dt date -- 授信日期
    ,crdt_lmt number(30,8) -- 授信额度
    ,lmt_status_cd varchar2(60) -- 额度状态代码
    ,lmt_effect_dt date -- 额度生效日期
    ,lmt_invalid_dt date -- 额度失效日期
    ,crdt_bus_type_cd varchar2(30) -- 授信业务类型代码
    ,crdt_update_dt date -- 授信更新日期
    ,froz_status_cd varchar2(30) -- 冻结状态代码
    ,appl_lmt_adj_dt date -- 申请额度调整日期
    ,lmt_adj_dt date -- 额度调整日期
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_belong_org_id varchar2(100) -- 登记所属机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_wyd_lmt_h to ${icl_schema};
grant select on ${iml_schema}.agt_wyd_lmt_h to ${idl_schema};
grant select on ${iml_schema}.agt_wyd_lmt_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wyd_lmt_h is '微业贷额度信息历史';
comment on column ${iml_schema}.agt_wyd_lmt_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wyd_lmt_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wyd_lmt_h.lmt_id is '额度编号';
comment on column ${iml_schema}.agt_wyd_lmt_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wyd_lmt_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_wyd_lmt_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_wyd_lmt_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_wyd_lmt_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wyd_lmt_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wyd_lmt_h.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_wyd_lmt_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_wyd_lmt_h.circl_lmt_flg is '循环额度标志';
comment on column ${iml_schema}.agt_wyd_lmt_h.crdt_id is '授信编号';
comment on column ${iml_schema}.agt_wyd_lmt_h.crdt_dt is '授信日期';
comment on column ${iml_schema}.agt_wyd_lmt_h.crdt_lmt is '授信额度';
comment on column ${iml_schema}.agt_wyd_lmt_h.lmt_status_cd is '额度状态代码';
comment on column ${iml_schema}.agt_wyd_lmt_h.lmt_effect_dt is '额度生效日期';
comment on column ${iml_schema}.agt_wyd_lmt_h.lmt_invalid_dt is '额度失效日期';
comment on column ${iml_schema}.agt_wyd_lmt_h.crdt_bus_type_cd is '授信业务类型代码';
comment on column ${iml_schema}.agt_wyd_lmt_h.crdt_update_dt is '授信更新日期';
comment on column ${iml_schema}.agt_wyd_lmt_h.froz_status_cd is '冻结状态代码';
comment on column ${iml_schema}.agt_wyd_lmt_h.appl_lmt_adj_dt is '申请额度调整日期';
comment on column ${iml_schema}.agt_wyd_lmt_h.lmt_adj_dt is '额度调整日期';
comment on column ${iml_schema}.agt_wyd_lmt_h.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_wyd_lmt_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wyd_lmt_h.rgst_belong_org_id is '登记所属机构编号';
comment on column ${iml_schema}.agt_wyd_lmt_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wyd_lmt_h.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_wyd_lmt_h.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_wyd_lmt_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_wyd_lmt_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wyd_lmt_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wyd_lmt_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wyd_lmt_h.etl_timestamp is 'ETL处理时间戳';
