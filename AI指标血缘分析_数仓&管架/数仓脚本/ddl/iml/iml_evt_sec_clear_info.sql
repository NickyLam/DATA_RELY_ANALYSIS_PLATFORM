/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_sec_clear_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_sec_clear_info
whenever sqlerror continue none;
drop table ${iml_schema}.evt_sec_clear_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_sec_clear_info(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,pay_id varchar2(100) -- 支付编号
    ,dept_id varchar2(100) -- 部门编号
    ,tran_cfm_id varchar2(100) -- 交易确认编号
    ,bus_table_name varchar2(150) -- 业务表名称
    ,bus_id varchar2(100) -- 业务编号
    ,tard_way_cd varchar2(30) -- 交易方式代码
    ,ser_num varchar2(100) -- 序列号
    ,acct_b_id varchar2(100) -- 账簿编号
    ,asset_type_name varchar2(150) -- 资产类型名称
    ,tran_cate_name varchar2(150) -- 交易类别名称
    ,tran_type_descb varchar2(150) -- 交易类型描述
    ,tran_descb varchar2(150) -- 交易描述
    ,dlvy_dt date -- 交割日期
    ,cntpty_id varchar2(100) -- 交易对手编号
    ,cntpty_name varchar2(375) -- 交易对手名称
    ,acpt_pay_type_cd varchar2(30) -- 收付类型代码
    ,dlvy_curr_cd varchar2(30) -- 交割币种代码
    ,contn_int_dlvy_tot_amt number(30,2) -- 含利息交割总金额
    ,dlvy_bond_id varchar2(100) -- 交割债券编号
    ,pric_dlvy_amt number(30,2) -- 本金交割金额
    ,actl_stl_dt date -- 实际结算日期
    ,actl_dlvy_curr_cd varchar2(30) -- 实际交割币种代码
    ,actl_contn_int_dlvy_tot_amt number(30,2) -- 实际含利息交割总金额
    ,actl_dlvy_bond_id varchar2(100) -- 实际交割债券编号
    ,actl_pric_dlvy_amt number(30,2) -- 实际本金交割金额
    ,status_cd varchar2(30) -- 状态代码
    ,dlvy_way_cd varchar2(30) -- 交割方式代码
    ,actl_dlvy_way_cd varchar2(30) -- 实际交割方式代码
    ,init_tran_id varchar2(100) -- 原交易编号
    ,bs_type_cd varchar2(30) -- 买卖类型代码
    ,ghb_tran_id varchar2(100) -- 本方交易编号
    ,ghb_bs_type_cd varchar2(30) -- 本方买卖类型代码
    ,ghb_cap_acct_en_name varchar2(750) -- 本方资金账户英文名称
    ,ghb_cap_acct_cn_name varchar2(750) -- 本方资金账户中文名称
    ,ghb_cap_open_bank_name varchar2(750) -- 本方资金开户行名称
    ,ghb_cap_acct_id varchar2(500) -- 本方资金账户编号
    ,ghb_cap_open_ibank_no varchar2(500) -- 本方资金开户联行号
    ,ghb_bond_acct_name varchar2(750) -- 本方债券账户名称
    ,ghb_bond_acct_bank_name varchar2(750) -- 本方债券账户银行名称
    ,ghb_bond_acct_id varchar2(500) -- 本方债券账户编号
    ,cntpty_tran_id varchar2(100) -- 交易对手交易编号
    ,cntpty_bs_type_cd varchar2(30) -- 对手方买卖类型代码
    ,cntpty_cap_acct_en_name varchar2(750) -- 对手方资金账户英文名称
    ,cntpty_cap_acct_cn_name varchar2(750) -- 对手方资金账户中文名称
    ,cntpty_cap_open_bank_name varchar2(750) -- 对手方资金开户行名称
    ,cntpty_cap_acct_id varchar2(500) -- 对手方资金账户编号
    ,cntpty_cap_open_ibank_no varchar2(500) -- 对手方资金开户联行号
    ,cntpty_bond_acct_name varchar2(750) -- 对手方债券账户名称
    ,cntpty_bond_acct_bank_name varchar2(750) -- 对手方债券账户银行名称
    ,cntpty_bond_acct_id varchar2(500) -- 对手方债券账户编号
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
grant select on ${iml_schema}.evt_sec_clear_info to ${icl_schema};
grant select on ${iml_schema}.evt_sec_clear_info to ${idl_schema};
grant select on ${iml_schema}.evt_sec_clear_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_sec_clear_info is '现券清算信息';
comment on column ${iml_schema}.evt_sec_clear_info.evt_id is '事件编号';
comment on column ${iml_schema}.evt_sec_clear_info.lp_id is '法人编号';
comment on column ${iml_schema}.evt_sec_clear_info.pay_id is '支付编号';
comment on column ${iml_schema}.evt_sec_clear_info.dept_id is '部门编号';
comment on column ${iml_schema}.evt_sec_clear_info.tran_cfm_id is '交易确认编号';
comment on column ${iml_schema}.evt_sec_clear_info.bus_table_name is '业务表名称';
comment on column ${iml_schema}.evt_sec_clear_info.bus_id is '业务编号';
comment on column ${iml_schema}.evt_sec_clear_info.tard_way_cd is '交易方式代码';
comment on column ${iml_schema}.evt_sec_clear_info.ser_num is '序列号';
comment on column ${iml_schema}.evt_sec_clear_info.acct_b_id is '账簿编号';
comment on column ${iml_schema}.evt_sec_clear_info.asset_type_name is '资产类型名称';
comment on column ${iml_schema}.evt_sec_clear_info.tran_cate_name is '交易类别名称';
comment on column ${iml_schema}.evt_sec_clear_info.tran_type_descb is '交易类型描述';
comment on column ${iml_schema}.evt_sec_clear_info.tran_descb is '交易描述';
comment on column ${iml_schema}.evt_sec_clear_info.dlvy_dt is '交割日期';
comment on column ${iml_schema}.evt_sec_clear_info.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.evt_sec_clear_info.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.evt_sec_clear_info.acpt_pay_type_cd is '收付类型代码';
comment on column ${iml_schema}.evt_sec_clear_info.dlvy_curr_cd is '交割币种代码';
comment on column ${iml_schema}.evt_sec_clear_info.contn_int_dlvy_tot_amt is '含利息交割总金额';
comment on column ${iml_schema}.evt_sec_clear_info.dlvy_bond_id is '交割债券编号';
comment on column ${iml_schema}.evt_sec_clear_info.pric_dlvy_amt is '本金交割金额';
comment on column ${iml_schema}.evt_sec_clear_info.actl_stl_dt is '实际结算日期';
comment on column ${iml_schema}.evt_sec_clear_info.actl_dlvy_curr_cd is '实际交割币种代码';
comment on column ${iml_schema}.evt_sec_clear_info.actl_contn_int_dlvy_tot_amt is '实际含利息交割总金额';
comment on column ${iml_schema}.evt_sec_clear_info.actl_dlvy_bond_id is '实际交割债券编号';
comment on column ${iml_schema}.evt_sec_clear_info.actl_pric_dlvy_amt is '实际本金交割金额';
comment on column ${iml_schema}.evt_sec_clear_info.status_cd is '状态代码';
comment on column ${iml_schema}.evt_sec_clear_info.dlvy_way_cd is '交割方式代码';
comment on column ${iml_schema}.evt_sec_clear_info.actl_dlvy_way_cd is '实际交割方式代码';
comment on column ${iml_schema}.evt_sec_clear_info.init_tran_id is '原交易编号';
comment on column ${iml_schema}.evt_sec_clear_info.bs_type_cd is '买卖类型代码';
comment on column ${iml_schema}.evt_sec_clear_info.ghb_tran_id is '本方交易编号';
comment on column ${iml_schema}.evt_sec_clear_info.ghb_bs_type_cd is '本方买卖类型代码';
comment on column ${iml_schema}.evt_sec_clear_info.ghb_cap_acct_en_name is '本方资金账户英文名称';
comment on column ${iml_schema}.evt_sec_clear_info.ghb_cap_acct_cn_name is '本方资金账户中文名称';
comment on column ${iml_schema}.evt_sec_clear_info.ghb_cap_open_bank_name is '本方资金开户行名称';
comment on column ${iml_schema}.evt_sec_clear_info.ghb_cap_acct_id is '本方资金账户编号';
comment on column ${iml_schema}.evt_sec_clear_info.ghb_cap_open_ibank_no is '本方资金开户联行号';
comment on column ${iml_schema}.evt_sec_clear_info.ghb_bond_acct_name is '本方债券账户名称';
comment on column ${iml_schema}.evt_sec_clear_info.ghb_bond_acct_bank_name is '本方债券账户银行名称';
comment on column ${iml_schema}.evt_sec_clear_info.ghb_bond_acct_id is '本方债券账户编号';
comment on column ${iml_schema}.evt_sec_clear_info.cntpty_tran_id is '交易对手交易编号';
comment on column ${iml_schema}.evt_sec_clear_info.cntpty_bs_type_cd is '对手方买卖类型代码';
comment on column ${iml_schema}.evt_sec_clear_info.cntpty_cap_acct_en_name is '对手方资金账户英文名称';
comment on column ${iml_schema}.evt_sec_clear_info.cntpty_cap_acct_cn_name is '对手方资金账户中文名称';
comment on column ${iml_schema}.evt_sec_clear_info.cntpty_cap_open_bank_name is '对手方资金开户行名称';
comment on column ${iml_schema}.evt_sec_clear_info.cntpty_cap_acct_id is '对手方资金账户编号';
comment on column ${iml_schema}.evt_sec_clear_info.cntpty_cap_open_ibank_no is '对手方资金开户联行号';
comment on column ${iml_schema}.evt_sec_clear_info.cntpty_bond_acct_name is '对手方债券账户名称';
comment on column ${iml_schema}.evt_sec_clear_info.cntpty_bond_acct_bank_name is '对手方债券账户银行名称';
comment on column ${iml_schema}.evt_sec_clear_info.cntpty_bond_acct_id is '对手方债券账户编号';
comment on column ${iml_schema}.evt_sec_clear_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_sec_clear_info.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_sec_clear_info.job_cd is '任务编码';
comment on column ${iml_schema}.evt_sec_clear_info.etl_timestamp is 'ETL处理时间戳';
