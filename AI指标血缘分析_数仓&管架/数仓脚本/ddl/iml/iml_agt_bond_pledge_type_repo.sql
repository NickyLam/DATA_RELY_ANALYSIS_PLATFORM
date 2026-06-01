/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_bond_pledge_type_repo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_bond_pledge_type_repo
whenever sqlerror continue none;
drop table ${iml_schema}.agt_bond_pledge_type_repo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bond_pledge_type_repo(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,bus_table_name varchar2(150) -- 业务表名称
    ,dept_id varchar2(60) -- 部门编号
    ,bond_id_comb varchar2(500) -- 债券编号组合
    ,bond_name_comb varchar2(4000) -- 债券名称组合
    ,tran_id varchar2(60) -- 交易编号
    ,fst_tran_dt date -- 首期交易日期
    ,fst_dlvy_dt date -- 首期交割日期
    ,exp_dlvy_dt date -- 到期交割日期
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,cert_face_tot_comb varchar2(750) -- 券面总额组合
    ,inpwn_ratio_comb varchar2(750) -- 质押比例组合
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
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(750) -- 交易对手名称
    ,fst_stl_way_cd varchar2(10) -- 首期结算方式代码
    ,exp_stl_way_cd varchar2(10) -- 到期结算方式代码
    ,dealer_id varchar2(60) -- 交易员编号
    ,dealer_name varchar2(150) -- 交易员名称
    ,bag_id varchar2(60) -- 成交编号
    ,cfets_tran_flg varchar2(10) -- CFETS交易标志
    ,repo_int_rat number(18,8) -- 回购利率
    ,repo_days number(18,0) -- 回购天数
    ,init_bus_id varchar2(60) -- 原业务编号
    ,repo_id varchar2(60) -- 回购编号
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,clear_type_cd varchar2(10) -- 清算类型代码
    ,acpt_pay_cfm_modif_tm timestamp -- 收付确认修改时间
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,dc_dealer_name varchar2(1500) -- 本币交易员名称
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
grant select on ${iml_schema}.agt_bond_pledge_type_repo to ${icl_schema};
grant select on ${iml_schema}.agt_bond_pledge_type_repo to ${idl_schema};
grant select on ${iml_schema}.agt_bond_pledge_type_repo to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_bond_pledge_type_repo is '债券质押式回购';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.agt_id is '协议编号';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.lp_id is '法人编号';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.bus_id is '业务编号';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.bus_table_name is '业务表名称';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.dept_id is '部门编号';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.bond_id_comb is '债券编号组合';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.bond_name_comb is '债券名称组合';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.tran_id is '交易编号';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.fst_tran_dt is '首期交易日期';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.fst_dlvy_dt is '首期交割日期';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.exp_dlvy_dt is '到期交割日期';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.cert_face_tot_comb is '券面总额组合';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.inpwn_ratio_comb is '质押比例组合';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.fst_stl_amt is '首期结算金额';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.exp_stl_amt is '到期结算金额';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.fst_fee is '首期费用';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.fst_tax is '首期税金';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.fst_comm is '首期佣金';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.acru_int is '应计利息';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.portf_id is '投组编号';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.portf_name is '投组名称';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.acct_b_id is '账簿编号';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.acct_b_name is '账簿名称';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.fst_stl_way_cd is '首期结算方式代码';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.exp_stl_way_cd is '到期结算方式代码';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.dealer_id is '交易员编号';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.dealer_name is '交易员名称';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.bag_id is '成交编号';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.cfets_tran_flg is 'CFETS交易标志';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.repo_int_rat is '回购利率';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.repo_days is '回购天数';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.init_bus_id is '原业务编号';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.repo_id is '回购编号';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.clear_type_cd is '清算类型代码';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.acpt_pay_cfm_modif_tm is '收付确认修改时间';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.dc_dealer_name is '本币交易员名称';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.create_dt is '创建日期';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.update_dt is '更新日期';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.id_mark is '增删标志';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.job_cd is '任务编码';
comment on column ${iml_schema}.agt_bond_pledge_type_repo.etl_timestamp is 'ETL处理时间戳';
