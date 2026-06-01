/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_bond_tran
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_bond_tran purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_bond_tran(
etl_dt date --ETL处理日期
,bus_id varchar2(60) --业务编号
,bus_table_name varchar2(100) --业务表名称
,dept_id varchar2(60) --部门编号
,bond_id varchar2(60) --债券编号
,bond_name varchar2(100) --债券名称
,bond_type_cd varchar2(10) --债券类型代码
,tran_id varchar2(60) --交易编号
,tran_dt date --交易日期
,dlvy_dt date --交割日期
,tran_dir_cd varchar2(10) --交易方向代码
,curr_cd varchar2(10) --币种代码
,tran_net_price number(18,10) --交易净价
,tran_full_price number(18,10) --交易全价
,exp_yld_rat number(18,10) --到期收益率
,stl_amt number(30,2) --转贴现金额
,portf_id varchar2(60) --投组编号
,portf_name varchar2(100) --投组名称
,acct_b_id varchar2(60) --账簿编号
,acct_b_name varchar2(100) --账簿名称
,acct_b_attr_cd varchar2(10) --账簿属性代码
,asset_cls4_cd varchar2(10) --资产四分类代码
,cntpty_name varchar2(100) --交易对手名称
,cntpty_id varchar2(60) --交易对手编号
,stl_way_cd varchar2(10) --结算方式代码
,dealer_id varchar2(60) --交易员编号
,dealer_name varchar2(100) --交易员名称
,bag_id varchar2(60) --成交编号
,comm_fee number(30,2) --手续费
,tax number(30,2) --税金
,comm number(30,2) --佣金
,cert_face_tot number(30,2) --券面总额
,acru_int_tot number(30,2) --应计利息总额
,cfets_tran_flg varchar2(10) --CFETS交易标志
,tran_src_cd varchar2(10) --交易来源代码
,asset_type_cd varchar2(10) --资产类型代码
,init_bus_id varchar2(60) --原业务编号
,acpt_pay_cfm_modif_tm timestamp(6) --收付确认修改时间
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,std_prod_id varchar2(60) --标准产品编号
,tran_status_cd varchar2(30) --交易状态代码
,dc_dealer_name varchar2(1000) --本币交易员名称
,agt_id varchar2(60) --协议编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_bond_tran to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_bond_tran is '债券交易';
comment on column ${idl_schema}.oass_agt_bond_tran.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_agt_bond_tran.bus_id is '业务编号';
comment on column ${idl_schema}.oass_agt_bond_tran.bus_table_name is '业务表名称';
comment on column ${idl_schema}.oass_agt_bond_tran.dept_id is '部门编号';
comment on column ${idl_schema}.oass_agt_bond_tran.bond_id is '债券编号';
comment on column ${idl_schema}.oass_agt_bond_tran.bond_name is '债券名称';
comment on column ${idl_schema}.oass_agt_bond_tran.bond_type_cd is '债券类型代码';
comment on column ${idl_schema}.oass_agt_bond_tran.tran_id is '交易编号';
comment on column ${idl_schema}.oass_agt_bond_tran.tran_dt is '交易日期';
comment on column ${idl_schema}.oass_agt_bond_tran.dlvy_dt is '交割日期';
comment on column ${idl_schema}.oass_agt_bond_tran.tran_dir_cd is '交易方向代码';
comment on column ${idl_schema}.oass_agt_bond_tran.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_agt_bond_tran.tran_net_price is '交易净价';
comment on column ${idl_schema}.oass_agt_bond_tran.tran_full_price is '交易全价';
comment on column ${idl_schema}.oass_agt_bond_tran.exp_yld_rat is '到期收益率';
comment on column ${idl_schema}.oass_agt_bond_tran.stl_amt is '转贴现金额';
comment on column ${idl_schema}.oass_agt_bond_tran.portf_id is '投组编号';
comment on column ${idl_schema}.oass_agt_bond_tran.portf_name is '投组名称';
comment on column ${idl_schema}.oass_agt_bond_tran.acct_b_id is '账簿编号';
comment on column ${idl_schema}.oass_agt_bond_tran.acct_b_name is '账簿名称';
comment on column ${idl_schema}.oass_agt_bond_tran.acct_b_attr_cd is '账簿属性代码';
comment on column ${idl_schema}.oass_agt_bond_tran.asset_cls4_cd is '资产四分类代码';
comment on column ${idl_schema}.oass_agt_bond_tran.cntpty_name is '交易对手名称';
comment on column ${idl_schema}.oass_agt_bond_tran.cntpty_id is '交易对手编号';
comment on column ${idl_schema}.oass_agt_bond_tran.stl_way_cd is '结算方式代码';
comment on column ${idl_schema}.oass_agt_bond_tran.dealer_id is '交易员编号';
comment on column ${idl_schema}.oass_agt_bond_tran.dealer_name is '交易员名称';
comment on column ${idl_schema}.oass_agt_bond_tran.bag_id is '成交编号';
comment on column ${idl_schema}.oass_agt_bond_tran.comm_fee is '手续费';
comment on column ${idl_schema}.oass_agt_bond_tran.tax is '税金';
comment on column ${idl_schema}.oass_agt_bond_tran.comm is '佣金';
comment on column ${idl_schema}.oass_agt_bond_tran.cert_face_tot is '券面总额';
comment on column ${idl_schema}.oass_agt_bond_tran.acru_int_tot is '应计利息总额';
comment on column ${idl_schema}.oass_agt_bond_tran.cfets_tran_flg is 'CFETS交易标志';
comment on column ${idl_schema}.oass_agt_bond_tran.tran_src_cd is '交易来源代码';
comment on column ${idl_schema}.oass_agt_bond_tran.asset_type_cd is '资产类型代码';
comment on column ${idl_schema}.oass_agt_bond_tran.init_bus_id is '原业务编号';
comment on column ${idl_schema}.oass_agt_bond_tran.acpt_pay_cfm_modif_tm is '收付确认修改时间';
comment on column ${idl_schema}.oass_agt_bond_tran.create_dt is '创建日期';
comment on column ${idl_schema}.oass_agt_bond_tran.update_dt is '更新日期';
comment on column ${idl_schema}.oass_agt_bond_tran.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_bond_tran.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.oass_agt_bond_tran.tran_status_cd is '交易状态代码';
comment on column ${idl_schema}.oass_agt_bond_tran.dc_dealer_name is '本币交易员名称';
comment on column ${idl_schema}.oass_agt_bond_tran.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_bond_tran.lp_id is '法人编号';

