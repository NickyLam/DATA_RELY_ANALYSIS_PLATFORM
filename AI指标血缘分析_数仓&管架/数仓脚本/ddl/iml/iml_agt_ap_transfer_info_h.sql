/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ap_transfer_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ap_transfer_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ap_transfer_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ap_transfer_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,disp_prop_id varchar2(100) -- 处置方案编号
    ,obj_id varchar2(100) -- 对象编号
    ,obj_type_cd varchar2(30) -- 对象类型代码
    ,prod_id varchar2(100) -- 产品编号
    ,stl_acct_id varchar2(250) -- 结算账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,level5_cls_cd varchar2(250) -- 五种分类代码
    ,curr_cd varchar2(30) -- 币种代码
    ,distr_amt number(30,8) -- 放款金额
    ,loan_bal number(30,8) -- 贷款余额
    ,recvbl_over_int number(30,8) -- 应收欠息
    ,acru_comp_int number(30,8) -- 应计复息
    ,recvbl_pnlt number(30,8) -- 应收罚息
    ,tran_amt number(30,8) -- 转让金额
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,up_date date -- 更新日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_ap_transfer_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_ap_transfer_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_ap_transfer_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ap_transfer_info_h is '资产转让债权信息历史';
comment on column ${iml_schema}.agt_ap_transfer_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ap_transfer_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ap_transfer_info_h.disp_prop_id is '处置方案编号';
comment on column ${iml_schema}.agt_ap_transfer_info_h.obj_id is '对象编号';
comment on column ${iml_schema}.agt_ap_transfer_info_h.obj_type_cd is '对象类型代码';
comment on column ${iml_schema}.agt_ap_transfer_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_ap_transfer_info_h.stl_acct_id is '结算账户编号';
comment on column ${iml_schema}.agt_ap_transfer_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_ap_transfer_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_ap_transfer_info_h.level5_cls_cd is '五种分类代码';
comment on column ${iml_schema}.agt_ap_transfer_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_ap_transfer_info_h.distr_amt is '放款金额';
comment on column ${iml_schema}.agt_ap_transfer_info_h.loan_bal is '贷款余额';
comment on column ${iml_schema}.agt_ap_transfer_info_h.recvbl_over_int is '应收欠息';
comment on column ${iml_schema}.agt_ap_transfer_info_h.acru_comp_int is '应计复息';
comment on column ${iml_schema}.agt_ap_transfer_info_h.recvbl_pnlt is '应收罚息';
comment on column ${iml_schema}.agt_ap_transfer_info_h.tran_amt is '转让金额';
comment on column ${iml_schema}.agt_ap_transfer_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_ap_transfer_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_ap_transfer_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_ap_transfer_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_ap_transfer_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_ap_transfer_info_h.up_date is '更新日期';
comment on column ${iml_schema}.agt_ap_transfer_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ap_transfer_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ap_transfer_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ap_transfer_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ap_transfer_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ap_transfer_info_h.etl_timestamp is 'ETL处理时间戳';
