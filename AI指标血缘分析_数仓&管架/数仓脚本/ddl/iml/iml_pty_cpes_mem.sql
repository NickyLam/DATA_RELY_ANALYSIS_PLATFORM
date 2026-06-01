/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_cpes_mem
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_cpes_mem
whenever sqlerror continue none;
drop table ${iml_schema}.pty_cpes_mem purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cpes_mem(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,mem_id varchar2(60) -- 会员编号
    ,mem_cd varchar2(60) -- 会员代码
    ,mem_org_cd varchar2(60) -- 会员机构代码
    ,mem_org_id varchar2(60) -- 会员机构编号
    ,org_cate_cd varchar2(10) -- 机构类别代码
    ,org_lev_cd varchar2(10) -- 机构级别代码
    ,org_cn_fname varchar2(750) -- 机构中文全称
    ,org_en_fname varchar2(375) -- 机构英文全称
    ,org_cn_abbr varchar2(375) -- 机构中文简称
    ,org_en_abbr varchar2(150) -- 机构英文简称
    ,unify_soci_crdt_cd varchar2(30) -- 统一社会信用代码
    ,dist_cd varchar2(10) -- 行政区划代码
    ,lp_lev_cd varchar2(10) -- 法人级别代码
    ,org_hibchy_cd varchar2(10) -- 机构层级代码
    ,prod_valid_dt date -- 产品有效日期
    ,prod_invalid_dt date -- 产品失效日期
    ,org_status_cd varchar2(10) -- 机构状态代码
    ,org_intnal_acct_name varchar2(150) -- 机构内部账户名称
    ,org_intnal_acct_num varchar2(60) -- 机构内部账户账号
    ,tran_acct_num varchar2(60) -- 交易账号
    ,tran_acct_status_cd varchar2(10) -- 交易账户状态代码
    ,trust_acct_num varchar2(60) -- 托管账号
    ,trust_acct_status_cd varchar2(10) -- 托管账户状态代码
    ,cpes_cap_acct_num varchar2(60) -- 票交所资金账户账号
    ,cpes_cap_acct_status_cd varchar2(10) -- 票交所资金账户状态代码
    ,legal_rep_or_princ varchar2(375) -- 法定代表人名称
    ,wdraw_acct_lg_pay_sys_bank_no varchar2(60) -- 出金账户开户行大额支付系统行号
    ,wdraw_acct_name varchar2(375) -- 出金账户名称
    ,wdraw_acct_num varchar2(60) -- 出金账户账号
    ,rgst_cap number(30,2) -- 注册资本
    ,addr varchar2(750) -- 地址
    ,cotas varchar2(150) -- 联系人
    ,phone varchar2(90) -- 联系电话
    ,fax varchar2(90) -- 传真
    ,zip_cd varchar2(90) -- 邮编
    ,sys_prtcptr_bigamt_bank_no varchar2(60) -- 系统参与者大额行号
    ,sys_prtcptr_bigamt_bank_name varchar2(750) -- 系统参与者大额行名
    ,ele_bill_agent_bigamt_bank_no varchar2(60) -- 电票代理行大额行号
    ,ele_bill_agent_bigamt_acct_num varchar2(60) -- 电票代理行大额账号
    ,udtake_org_cd varchar2(10) -- 承接机构代码
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
grant select on ${iml_schema}.pty_cpes_mem to ${icl_schema};
grant select on ${iml_schema}.pty_cpes_mem to ${idl_schema};
grant select on ${iml_schema}.pty_cpes_mem to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_cpes_mem is '票交所会员';
comment on column ${iml_schema}.pty_cpes_mem.party_id is '当事人编号';
comment on column ${iml_schema}.pty_cpes_mem.lp_id is '法人编号';
comment on column ${iml_schema}.pty_cpes_mem.mem_id is '会员编号';
comment on column ${iml_schema}.pty_cpes_mem.mem_cd is '会员代码';
comment on column ${iml_schema}.pty_cpes_mem.mem_org_cd is '会员机构代码';
comment on column ${iml_schema}.pty_cpes_mem.mem_org_id is '会员机构编号';
comment on column ${iml_schema}.pty_cpes_mem.org_cate_cd is '机构类别代码';
comment on column ${iml_schema}.pty_cpes_mem.org_lev_cd is '机构级别代码';
comment on column ${iml_schema}.pty_cpes_mem.org_cn_fname is '机构中文全称';
comment on column ${iml_schema}.pty_cpes_mem.org_en_fname is '机构英文全称';
comment on column ${iml_schema}.pty_cpes_mem.org_cn_abbr is '机构中文简称';
comment on column ${iml_schema}.pty_cpes_mem.org_en_abbr is '机构英文简称';
comment on column ${iml_schema}.pty_cpes_mem.unify_soci_crdt_cd is '统一社会信用代码';
comment on column ${iml_schema}.pty_cpes_mem.dist_cd is '行政区划代码';
comment on column ${iml_schema}.pty_cpes_mem.lp_lev_cd is '法人级别代码';
comment on column ${iml_schema}.pty_cpes_mem.org_hibchy_cd is '机构层级代码';
comment on column ${iml_schema}.pty_cpes_mem.prod_valid_dt is '产品有效日期';
comment on column ${iml_schema}.pty_cpes_mem.prod_invalid_dt is '产品失效日期';
comment on column ${iml_schema}.pty_cpes_mem.org_status_cd is '机构状态代码';
comment on column ${iml_schema}.pty_cpes_mem.org_intnal_acct_name is '机构内部账户名称';
comment on column ${iml_schema}.pty_cpes_mem.org_intnal_acct_num is '机构内部账户账号';
comment on column ${iml_schema}.pty_cpes_mem.tran_acct_num is '交易账号';
comment on column ${iml_schema}.pty_cpes_mem.tran_acct_status_cd is '交易账户状态代码';
comment on column ${iml_schema}.pty_cpes_mem.trust_acct_num is '托管账号';
comment on column ${iml_schema}.pty_cpes_mem.trust_acct_status_cd is '托管账户状态代码';
comment on column ${iml_schema}.pty_cpes_mem.cpes_cap_acct_num is '票交所资金账户账号';
comment on column ${iml_schema}.pty_cpes_mem.cpes_cap_acct_status_cd is '票交所资金账户状态代码';
comment on column ${iml_schema}.pty_cpes_mem.legal_rep_or_princ is '法定代表人名称';
comment on column ${iml_schema}.pty_cpes_mem.wdraw_acct_lg_pay_sys_bank_no is '出金账户开户行大额支付系统行号';
comment on column ${iml_schema}.pty_cpes_mem.wdraw_acct_name is '出金账户名称';
comment on column ${iml_schema}.pty_cpes_mem.wdraw_acct_num is '出金账户账号';
comment on column ${iml_schema}.pty_cpes_mem.rgst_cap is '注册资本';
comment on column ${iml_schema}.pty_cpes_mem.addr is '地址';
comment on column ${iml_schema}.pty_cpes_mem.cotas is '联系人';
comment on column ${iml_schema}.pty_cpes_mem.phone is '联系电话';
comment on column ${iml_schema}.pty_cpes_mem.fax is '传真';
comment on column ${iml_schema}.pty_cpes_mem.zip_cd is '邮编';
comment on column ${iml_schema}.pty_cpes_mem.sys_prtcptr_bigamt_bank_no is '系统参与者大额行号';
comment on column ${iml_schema}.pty_cpes_mem.sys_prtcptr_bigamt_bank_name is '系统参与者大额行名';
comment on column ${iml_schema}.pty_cpes_mem.ele_bill_agent_bigamt_bank_no is '电票代理行大额行号';
comment on column ${iml_schema}.pty_cpes_mem.ele_bill_agent_bigamt_acct_num is '电票代理行大额账号';
comment on column ${iml_schema}.pty_cpes_mem.udtake_org_cd is '承接机构代码';
comment on column ${iml_schema}.pty_cpes_mem.create_dt is '创建日期';
comment on column ${iml_schema}.pty_cpes_mem.update_dt is '更新日期';
comment on column ${iml_schema}.pty_cpes_mem.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_cpes_mem.id_mark is '增删标志';
comment on column ${iml_schema}.pty_cpes_mem.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_cpes_mem.job_cd is '任务编码';
comment on column ${iml_schema}.pty_cpes_mem.etl_timestamp is 'ETL处理时间戳';
