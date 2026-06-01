/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cap_ib_lend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cap_ib_lend
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cap_ib_lend purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cap_ib_lend(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,bus_table_name varchar2(150) -- 业务表名称
    ,dept_id varchar2(60) -- 部门编号
    ,tran_id varchar2(60) -- 交易编号
    ,fst_tran_dt date -- 首期交易日期
    ,fst_dlvy_dt date -- 首期交割日期
    ,exp_dlvy_dt date -- 到期交割日期
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,ib_lend_int_rat number(18,8) -- 拆借利率
    ,fst_stl_amt number(30,2) -- 首期结算金额
    ,exp_stl_amt number(30,2) -- 到期结算金额
    ,fst_fee number(30,2) -- 首期费用
    ,fst_tax number(30,2) -- 首期税金
    ,fst_comm number(30,2) -- 首期佣金
    ,acru_int number(30,2) -- 应计利息
    ,portf_id varchar2(60) -- 投组编号
    ,portf_name varchar2(150) -- 投组名称
    ,acct_b_id varchar2(60) -- 账簿编号
    ,acct_b_name varchar2(150) -- 账簿名称
    ,cntpty_name varchar2(750) -- 交易对手名称
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,dealer_id varchar2(60) -- 交易员编号
    ,dealer_name varchar2(150) -- 交易员名称
    ,bag_id varchar2(60) -- 成交编号
    ,cfets_tran_flg varchar2(10) -- CFETS交易标志
    ,ib_lend_days number(18,0) -- 拆借天数
    ,init_bus_id varchar2(60) -- 原业务编号
    ,tran_cate_cd varchar2(10) -- 交易类别代码
    ,repo_id varchar2(60) -- 回购编号
    ,acpt_pay_cfm_modif_tm timestamp -- 收付确认修改时间
    ,tran_status_cd varchar2(30) -- 交易状态代码
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
grant select on ${iml_schema}.agt_cap_ib_lend to ${icl_schema};
grant select on ${iml_schema}.agt_cap_ib_lend to ${idl_schema};
grant select on ${iml_schema}.agt_cap_ib_lend to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cap_ib_lend is '资金同业拆借';
comment on column ${iml_schema}.agt_cap_ib_lend.agt_id is '协议编号';
comment on column ${iml_schema}.agt_cap_ib_lend.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cap_ib_lend.bus_id is '业务编号';
comment on column ${iml_schema}.agt_cap_ib_lend.bus_table_name is '业务表名称';
comment on column ${iml_schema}.agt_cap_ib_lend.dept_id is '部门编号';
comment on column ${iml_schema}.agt_cap_ib_lend.tran_id is '交易编号';
comment on column ${iml_schema}.agt_cap_ib_lend.fst_tran_dt is '首期交易日期';
comment on column ${iml_schema}.agt_cap_ib_lend.fst_dlvy_dt is '首期交割日期';
comment on column ${iml_schema}.agt_cap_ib_lend.exp_dlvy_dt is '到期交割日期';
comment on column ${iml_schema}.agt_cap_ib_lend.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.agt_cap_ib_lend.ib_lend_int_rat is '拆借利率';
comment on column ${iml_schema}.agt_cap_ib_lend.fst_stl_amt is '首期结算金额';
comment on column ${iml_schema}.agt_cap_ib_lend.exp_stl_amt is '到期结算金额';
comment on column ${iml_schema}.agt_cap_ib_lend.fst_fee is '首期费用';
comment on column ${iml_schema}.agt_cap_ib_lend.fst_tax is '首期税金';
comment on column ${iml_schema}.agt_cap_ib_lend.fst_comm is '首期佣金';
comment on column ${iml_schema}.agt_cap_ib_lend.acru_int is '应计利息';
comment on column ${iml_schema}.agt_cap_ib_lend.portf_id is '投组编号';
comment on column ${iml_schema}.agt_cap_ib_lend.portf_name is '投组名称';
comment on column ${iml_schema}.agt_cap_ib_lend.acct_b_id is '账簿编号';
comment on column ${iml_schema}.agt_cap_ib_lend.acct_b_name is '账簿名称';
comment on column ${iml_schema}.agt_cap_ib_lend.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.agt_cap_ib_lend.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.agt_cap_ib_lend.dealer_id is '交易员编号';
comment on column ${iml_schema}.agt_cap_ib_lend.dealer_name is '交易员名称';
comment on column ${iml_schema}.agt_cap_ib_lend.bag_id is '成交编号';
comment on column ${iml_schema}.agt_cap_ib_lend.cfets_tran_flg is 'CFETS交易标志';
comment on column ${iml_schema}.agt_cap_ib_lend.ib_lend_days is '拆借天数';
comment on column ${iml_schema}.agt_cap_ib_lend.init_bus_id is '原业务编号';
comment on column ${iml_schema}.agt_cap_ib_lend.tran_cate_cd is '交易类别代码';
comment on column ${iml_schema}.agt_cap_ib_lend.repo_id is '回购编号';
comment on column ${iml_schema}.agt_cap_ib_lend.acpt_pay_cfm_modif_tm is '收付确认修改时间';
comment on column ${iml_schema}.agt_cap_ib_lend.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_cap_ib_lend.create_dt is '创建日期';
comment on column ${iml_schema}.agt_cap_ib_lend.update_dt is '更新日期';
comment on column ${iml_schema}.agt_cap_ib_lend.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_cap_ib_lend.id_mark is '增删标志';
comment on column ${iml_schema}.agt_cap_ib_lend.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cap_ib_lend.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cap_ib_lend.etl_timestamp is 'ETL处理时间戳';
