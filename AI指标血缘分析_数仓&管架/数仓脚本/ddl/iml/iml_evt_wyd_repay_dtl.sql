/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wyd_repay_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wyd_repay_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wyd_repay_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wyd_repay_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,repay_flow_num varchar2(100) -- 还款流水号
    ,cont_id varchar2(100) -- 合同编号
    ,dubil_id varchar2(100) -- 借据编号
    ,cust_id varchar2(100) -- 客户编号
    ,prod_id varchar2(100) -- 产品编号
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,repay_pric number(30,2) -- 还款本金
    ,repay_int number(30,2) -- 还款利息
    ,repay_pnlt number(30,2) -- 还款罚息
    ,repay_fee number(30,2) -- 还款费用
    ,repay_type_cd varchar2(30) -- 还款类型代码
    ,repay_dt date -- 还款日期
    ,in_bs_int number(30,2) -- 表内利息
    ,in_bs_pnlt number(30,2) -- 表内罚息
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
grant select on ${iml_schema}.evt_wyd_repay_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_wyd_repay_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_wyd_repay_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wyd_repay_dtl is '微业贷还款明细';
comment on column ${iml_schema}.evt_wyd_repay_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wyd_repay_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wyd_repay_dtl.repay_flow_num is '还款流水号';
comment on column ${iml_schema}.evt_wyd_repay_dtl.cont_id is '合同编号';
comment on column ${iml_schema}.evt_wyd_repay_dtl.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_wyd_repay_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_wyd_repay_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.evt_wyd_repay_dtl.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.evt_wyd_repay_dtl.repay_pric is '还款本金';
comment on column ${iml_schema}.evt_wyd_repay_dtl.repay_int is '还款利息';
comment on column ${iml_schema}.evt_wyd_repay_dtl.repay_pnlt is '还款罚息';
comment on column ${iml_schema}.evt_wyd_repay_dtl.repay_fee is '还款费用';
comment on column ${iml_schema}.evt_wyd_repay_dtl.repay_type_cd is '还款类型代码';
comment on column ${iml_schema}.evt_wyd_repay_dtl.repay_dt is '还款日期';
comment on column ${iml_schema}.evt_wyd_repay_dtl.in_bs_int is '表内利息';
comment on column ${iml_schema}.evt_wyd_repay_dtl.in_bs_pnlt is '表内罚息';
comment on column ${iml_schema}.evt_wyd_repay_dtl.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.evt_wyd_repay_dtl.rgst_belong_org_id is '登记所属机构编号';
comment on column ${iml_schema}.evt_wyd_repay_dtl.rgst_dt is '登记日期';
comment on column ${iml_schema}.evt_wyd_repay_dtl.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.evt_wyd_repay_dtl.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.evt_wyd_repay_dtl.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_wyd_repay_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wyd_repay_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wyd_repay_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wyd_repay_dtl.etl_timestamp is 'ETL处理时间戳';
