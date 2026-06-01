/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_bond_open_repo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_bond_open_repo
whenever sqlerror continue none;
drop table ${iml_schema}.agt_bond_open_repo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bond_open_repo(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,bus_table_name varchar2(150) -- 业务表名称
    ,dept_id varchar2(60) -- 部门编号
    ,tran_id varchar2(60) -- 交易编号
    ,portf_id varchar2(60) -- 投组编号
    ,portf_name varchar2(150) -- 投组名称
    ,acct_b_id varchar2(60) -- 账簿编号
    ,acct_b_name varchar2(150) -- 账簿名称
    ,curr_cd varchar2(10) -- 币种代码
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,fst_amt number(30,2) -- 首期金额
    ,tran_dt date -- 交易日期
    ,fst_dlvy_dt date -- 首期交割日期
    ,exp_dlvy_dt date -- 到期交割日期
    ,bond_id varchar2(60) -- 债券编号
    ,bond_name varchar2(150) -- 债券名称
    ,cert_face_tot number(30,2) -- 券面总额
    ,fst_net_price number(18,6) -- 首期净价
    ,exp_net_price number(18,6) -- 到期净价
    ,exp_amt number(30,2) -- 到期金额
    ,acru_int number(30,2) -- 应计利息
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(750) -- 交易对手名称
    ,dealer_id varchar2(60) -- 交易员编号
    ,dealer_name varchar2(150) -- 交易员名称
    ,fst_fee number(30,2) -- 首期费用
    ,fst_tax number(30,2) -- 首期税金
    ,fst_comm number(30,2) -- 首期佣金
    ,exp_fee number(30,2) -- 到期费用
    ,exp_tax number(30,2) -- 到期税金
    ,exp_comm number(30,2) -- 到期佣金
    ,tran_fee number(30,2) -- 交易费
    ,fst_dlvy_way_cd varchar2(10) -- 首期交割方式代码
    ,exp_dlvy_way_cd varchar2(10) -- 到期交割方式代码
    ,tran_src_cd varchar2(10) -- 交易来源代码
    ,cfets_tran_flg varchar2(10) -- CFETS交易标志
    ,near_end_link_denom number(30,2) -- 近端连结面额
    ,far_end_link_denom number(30,2) -- 远端连结面额
    ,link_init_tran_flg varchar2(10) -- 连结原始交易标志
    ,accti_method_cd varchar2(10) -- 核算方法代码
    ,init_bus_id varchar2(60) -- 原业务编号
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
grant select on ${iml_schema}.agt_bond_open_repo to ${icl_schema};
grant select on ${iml_schema}.agt_bond_open_repo to ${idl_schema};
grant select on ${iml_schema}.agt_bond_open_repo to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_bond_open_repo is '债券开放式回购';
comment on column ${iml_schema}.agt_bond_open_repo.agt_id is '协议编号';
comment on column ${iml_schema}.agt_bond_open_repo.lp_id is '法人编号';
comment on column ${iml_schema}.agt_bond_open_repo.bus_id is '业务编号';
comment on column ${iml_schema}.agt_bond_open_repo.bus_table_name is '业务表名称';
comment on column ${iml_schema}.agt_bond_open_repo.dept_id is '部门编号';
comment on column ${iml_schema}.agt_bond_open_repo.tran_id is '交易编号';
comment on column ${iml_schema}.agt_bond_open_repo.portf_id is '投组编号';
comment on column ${iml_schema}.agt_bond_open_repo.portf_name is '投组名称';
comment on column ${iml_schema}.agt_bond_open_repo.acct_b_id is '账簿编号';
comment on column ${iml_schema}.agt_bond_open_repo.acct_b_name is '账簿名称';
comment on column ${iml_schema}.agt_bond_open_repo.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_bond_open_repo.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.agt_bond_open_repo.fst_amt is '首期金额';
comment on column ${iml_schema}.agt_bond_open_repo.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_bond_open_repo.fst_dlvy_dt is '首期交割日期';
comment on column ${iml_schema}.agt_bond_open_repo.exp_dlvy_dt is '到期交割日期';
comment on column ${iml_schema}.agt_bond_open_repo.bond_id is '债券编号';
comment on column ${iml_schema}.agt_bond_open_repo.bond_name is '债券名称';
comment on column ${iml_schema}.agt_bond_open_repo.cert_face_tot is '券面总额';
comment on column ${iml_schema}.agt_bond_open_repo.fst_net_price is '首期净价';
comment on column ${iml_schema}.agt_bond_open_repo.exp_net_price is '到期净价';
comment on column ${iml_schema}.agt_bond_open_repo.exp_amt is '到期金额';
comment on column ${iml_schema}.agt_bond_open_repo.acru_int is '应计利息';
comment on column ${iml_schema}.agt_bond_open_repo.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.agt_bond_open_repo.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.agt_bond_open_repo.dealer_id is '交易员编号';
comment on column ${iml_schema}.agt_bond_open_repo.dealer_name is '交易员名称';
comment on column ${iml_schema}.agt_bond_open_repo.fst_fee is '首期费用';
comment on column ${iml_schema}.agt_bond_open_repo.fst_tax is '首期税金';
comment on column ${iml_schema}.agt_bond_open_repo.fst_comm is '首期佣金';
comment on column ${iml_schema}.agt_bond_open_repo.exp_fee is '到期费用';
comment on column ${iml_schema}.agt_bond_open_repo.exp_tax is '到期税金';
comment on column ${iml_schema}.agt_bond_open_repo.exp_comm is '到期佣金';
comment on column ${iml_schema}.agt_bond_open_repo.tran_fee is '交易费';
comment on column ${iml_schema}.agt_bond_open_repo.fst_dlvy_way_cd is '首期交割方式代码';
comment on column ${iml_schema}.agt_bond_open_repo.exp_dlvy_way_cd is '到期交割方式代码';
comment on column ${iml_schema}.agt_bond_open_repo.tran_src_cd is '交易来源代码';
comment on column ${iml_schema}.agt_bond_open_repo.cfets_tran_flg is 'CFETS交易标志';
comment on column ${iml_schema}.agt_bond_open_repo.near_end_link_denom is '近端连结面额';
comment on column ${iml_schema}.agt_bond_open_repo.far_end_link_denom is '远端连结面额';
comment on column ${iml_schema}.agt_bond_open_repo.link_init_tran_flg is '连结原始交易标志';
comment on column ${iml_schema}.agt_bond_open_repo.accti_method_cd is '核算方法代码';
comment on column ${iml_schema}.agt_bond_open_repo.init_bus_id is '原业务编号';
comment on column ${iml_schema}.agt_bond_open_repo.acpt_pay_cfm_modif_tm is '收付确认修改时间';
comment on column ${iml_schema}.agt_bond_open_repo.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_bond_open_repo.dc_dealer_name is '本币交易员名称';
comment on column ${iml_schema}.agt_bond_open_repo.create_dt is '创建日期';
comment on column ${iml_schema}.agt_bond_open_repo.update_dt is '更新日期';
comment on column ${iml_schema}.agt_bond_open_repo.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_bond_open_repo.id_mark is '增删标志';
comment on column ${iml_schema}.agt_bond_open_repo.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_bond_open_repo.job_cd is '任务编码';
comment on column ${iml_schema}.agt_bond_open_repo.etl_timestamp is 'ETL处理时间戳';
