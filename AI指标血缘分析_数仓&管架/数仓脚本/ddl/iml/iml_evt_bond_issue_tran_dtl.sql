/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bond_issue_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bond_issue_tran_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bond_issue_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bond_issue_tran_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_cd varchar2(60) -- 法人代码
    ,bus_id varchar2(100) -- 业务编号
    ,bus_table_name varchar2(150) -- 业务表名称
    ,dept_id varchar2(100) -- 部门编号
    ,bond_id varchar2(100) -- 债券编号
    ,bond_name varchar2(150) -- 债券名称
    ,bond_type_cd varchar2(30) -- 债券类型代码
    ,tran_id varchar2(100) -- 交易编号
    ,tran_dt date -- 交易日期
    ,dlvy_dt date -- 交割日期
    ,tran_dir_cd varchar2(30) -- 交易方向代码
    ,tran_net_price number(30,2) -- 交易净价
    ,tran_full_price number(30,2) -- 交易全价
    ,exp_yld_rat number(18,8) -- 到期收益率
    ,stl_amt number(30,2) -- 转贴现金额
    ,portf_id varchar2(100) -- 投组编号
    ,portf_name varchar2(150) -- 投组名称
    ,acct_b_id varchar2(100) -- 账簿编号
    ,acct_b_name varchar2(150) -- 账簿名称
    ,acct_b_attr_cd varchar2(30) -- 账簿属性代码
    ,asset_cls4_name varchar2(45) -- 资产四分类名称
    ,stl_way_cd varchar2(30) -- 结算方式代码
    ,dealer_id varchar2(100) -- 交易员编号
    ,dealer_name varchar2(150) -- 交易员名称
    ,cert_face_tot number(30,2) -- 券面总额
    ,cfets_tran_flg varchar2(10) -- CFETS交易标志
    ,tran_src_cd varchar2(30) -- 交易来源代码
    ,asset_type_cd varchar2(30) -- 资产类型代码
    ,acpt_pay_cfm_modif_tm timestamp -- 收付确认修改时间
    ,issue_status_cd varchar2(30) -- 发行状态代码
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
grant select on ${iml_schema}.evt_bond_issue_tran_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_bond_issue_tran_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_bond_issue_tran_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bond_issue_tran_dtl is '债券发行交易明细';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.lp_cd is '法人代码';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.bus_id is '业务编号';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.bus_table_name is '业务表名称';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.dept_id is '部门编号';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.bond_id is '债券编号';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.bond_name is '债券名称';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.bond_type_cd is '债券类型代码';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.tran_id is '交易编号';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.dlvy_dt is '交割日期';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.tran_net_price is '交易净价';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.tran_full_price is '交易全价';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.exp_yld_rat is '到期收益率';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.stl_amt is '转贴现金额';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.portf_id is '投组编号';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.portf_name is '投组名称';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.acct_b_id is '账簿编号';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.acct_b_name is '账簿名称';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.acct_b_attr_cd is '账簿属性代码';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.asset_cls4_name is '资产四分类名称';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.stl_way_cd is '结算方式代码';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.dealer_id is '交易员编号';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.dealer_name is '交易员名称';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.cert_face_tot is '券面总额';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.cfets_tran_flg is 'CFETS交易标志';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.tran_src_cd is '交易来源代码';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.asset_type_cd is '资产类型代码';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.acpt_pay_cfm_modif_tm is '收付确认修改时间';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.issue_status_cd is '发行状态代码';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bond_issue_tran_dtl.etl_timestamp is 'ETL处理时间戳';
