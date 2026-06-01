/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_agt_fx_spot
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_agt_fx_spot
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_agt_fx_spot purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_agt_fx_spot(
    etl_dt date -- 数据日期
    ,agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,dept_id varchar2(60) -- 部门编号
    ,org_id varchar2(60) -- 机构编号
    ,input_dt date -- 录入日期
    ,tran_dt date -- 交易日期
    ,value_dt date -- 起息日期
    ,curr_pairs_id varchar2(60) -- 货币对编号
    ,bag_exch_rat number(18,8) -- 成交汇率
    ,brch_exch_rat number(18,8) -- 分行汇率
    ,cost_exch_rat number(18,8) -- 成本汇率
    ,fst_curr_cd varchar2(10) -- 第一币种代码
    ,secd_curr_cd varchar2(10) -- 第二货币代码
    ,fst_curr_tran_amt number(30,2) -- 第一币种交易金额
    ,secd_curr_tran_amt number(30,2) -- 第二币种交易金额
    ,tran_aim_cd varchar2(10) -- 交易目的代码
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_abbr varchar2(500) -- 交易对手简称
    ,tran_splt_type_cd varchar2(10) -- 交易拆分类型代码
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,ctr_nt_status_cd varchar2(10) -- 成交单状态代码
    ,bag_id varchar2(60) -- 成交编号
    ,tran_mode_cd varchar2(10) -- 交易模式代码
    ,tran_src_cd varchar2(10) -- 交易来源代码
    ,tran_site_cd varchar2(10) -- 交易场所代码
    ,clear_way_cd varchar2(10) -- 清算方式代码
    ,rela_tran_id varchar2(60) -- 关联交易编号
    ,portf_tran_id varchar2(60) -- 投组交易编号
    ,portf_id varchar2(60) -- 投组编号
    ,portf_name varchar2(500) -- 投组名称
    ,portf_type_name varchar2(100) -- 投组类型名称
    ,portf_status_cd varchar2(10) -- 投组状态代码
    ,portf_rela_tran_id varchar2(60) -- 投组关联交易编号
    ,clear_org_cd varchar2(10) -- 清算机构代码
    ,modif_rela_flow_num varchar2(60) -- 交易修改关联流水号
    ,job_cd varchar2(10) -- 任务代码
    ,dealer_acct_num varchar2(100)   --交易员账号
    ,create_dt       date            --创建日期 
    ,update_dt       date            --更新日期 
    ,id_mark         varchar2(10)    --删除标识     
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_agt_fx_spot to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_agt_fx_spot is '外汇即期交易';
comment on column ${idl_schema}.icrm_agt_fx_spot.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_agt_fx_spot.agt_id is '协议编号';
comment on column ${idl_schema}.icrm_agt_fx_spot.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_agt_fx_spot.bus_id is '业务编号';
comment on column ${idl_schema}.icrm_agt_fx_spot.dept_id is '部门编号';
comment on column ${idl_schema}.icrm_agt_fx_spot.org_id is '机构编号';
comment on column ${idl_schema}.icrm_agt_fx_spot.input_dt is '录入日期';
comment on column ${idl_schema}.icrm_agt_fx_spot.tran_dt is '交易日期';
comment on column ${idl_schema}.icrm_agt_fx_spot.value_dt is '起息日期';
comment on column ${idl_schema}.icrm_agt_fx_spot.curr_pairs_id is '货币对编号';
comment on column ${idl_schema}.icrm_agt_fx_spot.bag_exch_rat is '成交汇率';
comment on column ${idl_schema}.icrm_agt_fx_spot.brch_exch_rat is '分行汇率';
comment on column ${idl_schema}.icrm_agt_fx_spot.cost_exch_rat is '成本汇率';
comment on column ${idl_schema}.icrm_agt_fx_spot.fst_curr_cd is '第一币种代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.secd_curr_cd is '第二货币代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.fst_curr_tran_amt is '第一币种交易金额';
comment on column ${idl_schema}.icrm_agt_fx_spot.secd_curr_tran_amt is '第二币种交易金额';
comment on column ${idl_schema}.icrm_agt_fx_spot.tran_aim_cd is '交易目的代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.cntpty_id is '交易对手编号';
comment on column ${idl_schema}.icrm_agt_fx_spot.cntpty_abbr is '交易对手简称';
comment on column ${idl_schema}.icrm_agt_fx_spot.tran_splt_type_cd is '交易拆分类型代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.tran_dir_cd is '交易方向代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.tran_flow_num is '交易流水号';
comment on column ${idl_schema}.icrm_agt_fx_spot.ctr_nt_status_cd is '成交单状态代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.bag_id is '成交编号';
comment on column ${idl_schema}.icrm_agt_fx_spot.tran_mode_cd is '交易模式代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.tran_src_cd is '交易来源代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.tran_site_cd is '交易场所代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.clear_way_cd is '清算方式代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.rela_tran_id is '关联交易编号';
comment on column ${idl_schema}.icrm_agt_fx_spot.portf_tran_id is '投组交易编号';
comment on column ${idl_schema}.icrm_agt_fx_spot.portf_id is '投组编号';
comment on column ${idl_schema}.icrm_agt_fx_spot.portf_name is '投组名称';
comment on column ${idl_schema}.icrm_agt_fx_spot.portf_type_name is '投组类型名称';
comment on column ${idl_schema}.icrm_agt_fx_spot.portf_status_cd is '投组状态代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.portf_rela_tran_id is '投组关联交易编号';
comment on column ${idl_schema}.icrm_agt_fx_spot.clear_org_cd is '清算机构代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.modif_rela_flow_num is '交易修改关联流水号';
comment on column ${idl_schema}.icrm_agt_fx_spot.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_agt_fx_spot.etl_timestamp is '数据处理时间';
comment on column ${idl_schema}.icrm_agt_fx_spot.dealer_acct_num is '交易员账号';
comment on column ${idl_schema}.icrm_agt_fx_spot.create_dt is '创建日期';
comment on column ${idl_schema}.icrm_agt_fx_spot.update_dt is '更新日期';
comment on column ${idl_schema}.icrm_agt_fx_spot.id_mark is '删除标识';
