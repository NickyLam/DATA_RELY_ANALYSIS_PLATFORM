/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_fx_fitran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_fx_fitran
whenever sqlerror continue none;
drop table ${iml_schema}.agt_fx_fitran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fx_fitran(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,dept_id varchar2(60) -- 部门编号
    ,org_id varchar2(60) -- 机构编号
    ,input_dt date -- 录入日期
    ,tran_dt date -- 交易日期
    ,fitran_dt date -- 头寸调拨日期
    ,cannib_type_cd varchar2(10) -- 调拨类型代码
    ,curr_cd varchar2(10) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_aim_cd varchar2(10) -- 交易目的代码
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(750) -- 交易对手名称
    ,bag_flow_num varchar2(60) -- 成交流水号
    ,ctr_nt_status_cd varchar2(10) -- 成交单状态代码
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,bag_id varchar2(60) -- 成交编号
    ,tran_mode_cd varchar2(10) -- 交易模式代码
    ,tran_src_cd varchar2(10) -- 交易来源代码
    ,tran_site_cd varchar2(10) -- 交易场所代码
    ,clear_way_cd varchar2(10) -- 清算方式代码
    ,rela_tran_id varchar2(60) -- 关联交易编号
    ,portf_tran_id varchar2(60) -- 投组交易编号
    ,portf_id varchar2(60) -- 投组编号
    ,portf_name varchar2(750) -- 投组名称
    ,portf_type_name varchar2(150) -- 投组类型名称
    ,inv_port_status_cd varchar2(10) -- 投资组合状态代码
    ,portf_rela_tran_id varchar2(60) -- 投组关联交易编号
    ,amt_type_cd varchar2(10) -- 金额类型代码
    ,stl_status_cd varchar2(10) -- 结算状态代码
    ,r_bk_acct_id varchar2(60) -- 划出行账户编号
    ,p_bk_acct_id varchar2(60) -- 划入行账户编号
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.agt_fx_fitran to ${icl_schema};
grant select on ${iml_schema}.agt_fx_fitran to ${idl_schema};
grant select on ${iml_schema}.agt_fx_fitran to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_fx_fitran is '外汇头寸调拨';
comment on column ${iml_schema}.agt_fx_fitran.agt_id is '协议编号';
comment on column ${iml_schema}.agt_fx_fitran.lp_id is '法人编号';
comment on column ${iml_schema}.agt_fx_fitran.bus_id is '业务编号';
comment on column ${iml_schema}.agt_fx_fitran.dept_id is '部门编号';
comment on column ${iml_schema}.agt_fx_fitran.org_id is '机构编号';
comment on column ${iml_schema}.agt_fx_fitran.input_dt is '录入日期';
comment on column ${iml_schema}.agt_fx_fitran.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_fx_fitran.fitran_dt is '头寸调拨日期';
comment on column ${iml_schema}.agt_fx_fitran.cannib_type_cd is '调拨类型代码';
comment on column ${iml_schema}.agt_fx_fitran.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_fx_fitran.tran_amt is '交易金额';
comment on column ${iml_schema}.agt_fx_fitran.tran_aim_cd is '交易目的代码';
comment on column ${iml_schema}.agt_fx_fitran.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.agt_fx_fitran.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.agt_fx_fitran.bag_flow_num is '成交流水号';
comment on column ${iml_schema}.agt_fx_fitran.ctr_nt_status_cd is '成交单状态代码';
comment on column ${iml_schema}.agt_fx_fitran.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.agt_fx_fitran.bag_id is '成交编号';
comment on column ${iml_schema}.agt_fx_fitran.tran_mode_cd is '交易模式代码';
comment on column ${iml_schema}.agt_fx_fitran.tran_src_cd is '交易来源代码';
comment on column ${iml_schema}.agt_fx_fitran.tran_site_cd is '交易场所代码';
comment on column ${iml_schema}.agt_fx_fitran.clear_way_cd is '清算方式代码';
comment on column ${iml_schema}.agt_fx_fitran.rela_tran_id is '关联交易编号';
comment on column ${iml_schema}.agt_fx_fitran.portf_tran_id is '投组交易编号';
comment on column ${iml_schema}.agt_fx_fitran.portf_id is '投组编号';
comment on column ${iml_schema}.agt_fx_fitran.portf_name is '投组名称';
comment on column ${iml_schema}.agt_fx_fitran.portf_type_name is '投组类型名称';
comment on column ${iml_schema}.agt_fx_fitran.inv_port_status_cd is '投资组合状态代码';
comment on column ${iml_schema}.agt_fx_fitran.portf_rela_tran_id is '投组关联交易编号';
comment on column ${iml_schema}.agt_fx_fitran.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.agt_fx_fitran.stl_status_cd is '结算状态代码';
comment on column ${iml_schema}.agt_fx_fitran.r_bk_acct_id is '划出行账户编号';
comment on column ${iml_schema}.agt_fx_fitran.p_bk_acct_id is '划入行账户编号';
comment on column ${iml_schema}.agt_fx_fitran.create_dt is '创建日期';
comment on column ${iml_schema}.agt_fx_fitran.update_dt is '更新日期';
comment on column ${iml_schema}.agt_fx_fitran.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_fx_fitran.id_mark is '增删标志';
comment on column ${iml_schema}.agt_fx_fitran.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_fx_fitran.job_cd is '任务编码';
comment on column ${iml_schema}.agt_fx_fitran.etl_timestamp is 'ETL处理时间戳';
