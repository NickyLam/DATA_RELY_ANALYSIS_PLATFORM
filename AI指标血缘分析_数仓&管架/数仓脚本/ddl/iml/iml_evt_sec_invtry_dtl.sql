/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_sec_invtry_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_sec_invtry_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_sec_invtry_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_sec_invtry_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,que_dt date -- 查询日期
    ,oper_dt date -- 操作日期
    ,trust_org_id varchar2(2000) -- 托管机构编号
    ,trust_org_name varchar2(4000) -- 托管机构名称
    ,bond_id varchar2(100) -- 债券编号
    ,bond_name varchar2(4000) -- 债券名称
    ,bond_cate_name varchar2(500) -- 债券类别名称
    ,bond_exp_dt date -- 债券到期日期
    ,sh_term_post_flg varchar2(10) -- 短仓标志
    ,full_price number(30,2) -- 全价
    ,bond_rating_cd varchar2(30) -- 债券评级代码
    ,intnal_rating_cd varchar2(30) -- 内部评级代码
    ,main_rating_cd varchar2(30) -- 主体评级代码
    ,group_group_id varchar2(100) -- 群组编号
    ,group_group_name varchar2(4000) -- 群组名称
    ,portf_id varchar2(100) -- 投组编号
    ,portf_name varchar2(4000) -- 投组名称
    ,aval_amt number(30,2) -- 可用金额
    ,bond_debit_crdt_in_amt number(30,2) -- 债券借贷融入金额
    ,bond_debit_crdt_in_aval_amt number(30,2) -- 债券借贷融入可用金额
    ,sec_amt number(30,2) -- 现券金额
    ,sec_aval_amt number(30,2) -- 现券可用金额
    ,agt_repo_amt number(30,2) -- 协议回购金额
    ,fin_amt number(30,2) -- 可融资金额
    ,fin_inpwn_ratio number(18,6) -- 可融资质押比例
    ,pledge_plus_repo_amt number(30,2) -- 质押式正回购金额
    ,inpwn_vch_tot_amt number(30,2) -- 质押券总金额
    ,open_plus_repo_amt number(30,2) -- 开放式正回购金额
    ,open_rev_repo_amt number(30,2) -- 开放式逆回购金额
    ,open_rev_repo_aval_amt number(30,2) -- 开放式逆回购可用金额
    ,td_exp_inpwn_vch_amt number(30,2) -- 当日到期质押券金额
    ,buyout_plus_repo_amt number(30,2) -- 买断式正回购金额
    ,buyout_rev_repo_amt number(30,2) -- 买断式逆回购金额
    ,buyout_rev_repo_aval_amt number(30,2) -- 买断式逆回购可用金额
    ,bond_debit_crdt_inwdraw_lmt number(30,2) -- 债券借贷质押出金额
    ,bond_debit_crdt_wdraw_lmt number(30,2) -- 债券借贷融出金额
    ,trust_vch_tot_amt number(30,2) -- 托管券总金额
    ,manual_adj_post_amt number(30,2) -- 手动调仓金额
    ,evltion_net_price number(30,2) -- 估值净价
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
grant select on ${iml_schema}.evt_sec_invtry_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_sec_invtry_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_sec_invtry_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_sec_invtry_dtl is '现券库存明细';
comment on column ${iml_schema}.evt_sec_invtry_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_sec_invtry_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_sec_invtry_dtl.que_dt is '查询日期';
comment on column ${iml_schema}.evt_sec_invtry_dtl.oper_dt is '操作日期';
comment on column ${iml_schema}.evt_sec_invtry_dtl.trust_org_id is '托管机构编号';
comment on column ${iml_schema}.evt_sec_invtry_dtl.trust_org_name is '托管机构名称';
comment on column ${iml_schema}.evt_sec_invtry_dtl.bond_id is '债券编号';
comment on column ${iml_schema}.evt_sec_invtry_dtl.bond_name is '债券名称';
comment on column ${iml_schema}.evt_sec_invtry_dtl.bond_cate_name is '债券类别名称';
comment on column ${iml_schema}.evt_sec_invtry_dtl.bond_exp_dt is '债券到期日期';
comment on column ${iml_schema}.evt_sec_invtry_dtl.sh_term_post_flg is '短仓标志';
comment on column ${iml_schema}.evt_sec_invtry_dtl.full_price is '全价';
comment on column ${iml_schema}.evt_sec_invtry_dtl.bond_rating_cd is '债券评级代码';
comment on column ${iml_schema}.evt_sec_invtry_dtl.intnal_rating_cd is '内部评级代码';
comment on column ${iml_schema}.evt_sec_invtry_dtl.main_rating_cd is '主体评级代码';
comment on column ${iml_schema}.evt_sec_invtry_dtl.group_group_id is '群组编号';
comment on column ${iml_schema}.evt_sec_invtry_dtl.group_group_name is '群组名称';
comment on column ${iml_schema}.evt_sec_invtry_dtl.portf_id is '投组编号';
comment on column ${iml_schema}.evt_sec_invtry_dtl.portf_name is '投组名称';
comment on column ${iml_schema}.evt_sec_invtry_dtl.aval_amt is '可用金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.bond_debit_crdt_in_amt is '债券借贷融入金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.bond_debit_crdt_in_aval_amt is '债券借贷融入可用金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.sec_amt is '现券金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.sec_aval_amt is '现券可用金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.agt_repo_amt is '协议回购金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.fin_amt is '可融资金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.fin_inpwn_ratio is '可融资质押比例';
comment on column ${iml_schema}.evt_sec_invtry_dtl.pledge_plus_repo_amt is '质押式正回购金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.inpwn_vch_tot_amt is '质押券总金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.open_plus_repo_amt is '开放式正回购金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.open_rev_repo_amt is '开放式逆回购金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.open_rev_repo_aval_amt is '开放式逆回购可用金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.td_exp_inpwn_vch_amt is '当日到期质押券金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.buyout_plus_repo_amt is '买断式正回购金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.buyout_rev_repo_amt is '买断式逆回购金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.buyout_rev_repo_aval_amt is '买断式逆回购可用金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.bond_debit_crdt_inwdraw_lmt is '债券借贷质押出金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.bond_debit_crdt_wdraw_lmt is '债券借贷融出金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.trust_vch_tot_amt is '托管券总金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.manual_adj_post_amt is '手动调仓金额';
comment on column ${iml_schema}.evt_sec_invtry_dtl.evltion_net_price is '估值净价';
comment on column ${iml_schema}.evt_sec_invtry_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_sec_invtry_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_sec_invtry_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_sec_invtry_dtl.etl_timestamp is 'ETL处理时间戳';
