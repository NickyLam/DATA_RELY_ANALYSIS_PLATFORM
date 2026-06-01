/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_pty_cpes_mem
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${idl_schema}.pty_cpes_mem drop partition p_${last_date};
alter table ${idl_schema}.pty_cpes_mem drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.pty_cpes_mem add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.pty_cpes_mem (
    etl_dt  -- 数据日期
    ,party_id  -- 当事人编号
    ,lp_id  -- 法人编号
    ,mem_id  -- 会员编号
    ,mem_cd  -- 会员代码
    ,mem_org_cd  -- 会员机构代码
    ,mem_org_id  -- 会员机构编号
    ,org_cate_cd  -- 机构类别代码
    ,org_lev_cd  -- 机构级别代码
    ,org_cn_fname  -- 机构中文全称
    ,org_en_fname  -- 机构英文全称
    ,org_cn_abbr  -- 机构中文简称
    ,org_en_abbr  -- 机构英文简称
    ,unify_soci_crdt_cd  -- 统一社会信用代码
    ,dist_cd  -- 行政区划代码
    ,lp_lev_cd  -- 法人级别代码
    ,org_hibchy_cd  -- 机构层级代码
    ,prod_valid_dt  -- 产品有效日期
    ,prod_invalid_dt  -- 产品失效日期
    ,org_status_cd  -- 机构状态代码
    ,org_intnal_acct_name  -- 机构内部账户名称
    ,org_intnal_acct_num  -- 机构内部账户账号
    ,tran_acct_num  -- 交易账号
    ,tran_acct_status_cd  -- 交易账户状态代码
    ,trust_acct_num  -- 托管账号
    ,trust_acct_status_cd  -- 托管账户状态代码
    ,cpes_cap_acct_num  -- 票交所资金账户账号
    ,cpes_cap_acct_status_cd  -- 票交所资金账户状态代码
    ,legal_rep_or_princ  -- 法定代表人或负责人
    ,wdraw_acct_lg_pay_sys_bank_no  -- 出金账户开户行大额支付系统行号
    ,wdraw_acct_name  -- 出金账户名称
    ,wdraw_acct_num  -- 出金账户账号
    ,rgst_cap  -- 注册资本
    ,addr  -- 地址
    ,cotas  -- 联系人
    ,phone  -- 联系电话
    ,fax  -- 传真
    ,zip_cd  -- 邮编
    ,sys_prtcptr_bigamt_bank_no  -- 系统参与者大额行号
    ,sys_prtcptr_bigamt_bank_name  -- 系统参与者大额行名
    ,ele_bill_agent_bigamt_bank_no  -- 电票代理行大额行号
    ,ele_bill_agent_bigamt_acct_num  -- 电票代理行大额账号
    ,udtake_org_cd  -- 承接机构代码
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.party_id,chr(13),''),chr(10),'')  -- 当事人编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.mem_id,chr(13),''),chr(10),'')  -- 会员编号
    ,replace(replace(t1.mem_cd,chr(13),''),chr(10),'')  -- 会员代码
    ,replace(replace(t1.mem_org_cd,chr(13),''),chr(10),'')  -- 会员机构代码
    ,replace(replace(t1.mem_org_id,chr(13),''),chr(10),'')  -- 会员机构编号
    ,replace(replace(t1.org_cate_cd,chr(13),''),chr(10),'')  -- 机构类别代码
    ,replace(replace(t1.org_lev_cd,chr(13),''),chr(10),'')  -- 机构级别代码
    ,replace(replace(t1.org_cn_fname,chr(13),''),chr(10),'')  -- 机构中文全称
    ,replace(replace(t1.org_en_fname,chr(13),''),chr(10),'')  -- 机构英文全称
    ,replace(replace(t1.org_cn_abbr,chr(13),''),chr(10),'')  -- 机构中文简称
    ,replace(replace(t1.org_en_abbr,chr(13),''),chr(10),'')  -- 机构英文简称
    ,replace(replace(t1.unify_soci_crdt_cd,chr(13),''),chr(10),'')  -- 统一社会信用代码
    ,replace(replace(t1.dist_cd,chr(13),''),chr(10),'')  -- 行政区划代码
    ,replace(replace(t1.lp_lev_cd,chr(13),''),chr(10),'')  -- 法人级别代码
    ,replace(replace(t1.org_hibchy_cd,chr(13),''),chr(10),'')  -- 机构层级代码
    ,t1.prod_valid_dt  -- 产品有效日期
    ,t1.prod_invalid_dt  -- 产品失效日期
    ,replace(replace(t1.org_status_cd,chr(13),''),chr(10),'')  -- 机构状态代码
    ,replace(replace(t1.org_intnal_acct_name,chr(13),''),chr(10),'')  -- 机构内部账户名称
    ,replace(replace(t1.org_intnal_acct_num,chr(13),''),chr(10),'')  -- 机构内部账户账号
    ,replace(replace(t1.tran_acct_num,chr(13),''),chr(10),'')  -- 交易账号
    ,replace(replace(t1.tran_acct_status_cd,chr(13),''),chr(10),'')  -- 交易账户状态代码
    ,replace(replace(t1.trust_acct_num,chr(13),''),chr(10),'')  -- 托管账号
    ,replace(replace(t1.trust_acct_status_cd,chr(13),''),chr(10),'')  -- 托管账户状态代码
    ,replace(replace(t1.cpes_cap_acct_num,chr(13),''),chr(10),'')  -- 票交所资金账户账号
    ,replace(replace(t1.cpes_cap_acct_status_cd,chr(13),''),chr(10),'')  -- 票交所资金账户状态代码
    ,replace(replace(t1.legal_rep_or_princ,chr(13),''),chr(10),'')  -- 法定代表人或负责人
    ,replace(replace(t1.wdraw_acct_lg_pay_sys_bank_no,chr(13),''),chr(10),'')  -- 出金账户开户行大额支付系统行号
    ,replace(replace(t1.wdraw_acct_name,chr(13),''),chr(10),'')  -- 出金账户名称
    ,replace(replace(t1.wdraw_acct_num,chr(13),''),chr(10),'')  -- 出金账户账号
    ,t1.rgst_cap  -- 注册资本
    ,replace(replace(t1.addr,chr(13),''),chr(10),'')  -- 地址
    ,replace(replace(t1.cotas,chr(13),''),chr(10),'')  -- 联系人
    ,replace(replace(t1.phone,chr(13),''),chr(10),'')  -- 联系电话
    ,replace(replace(t1.fax,chr(13),''),chr(10),'')  -- 传真
    ,replace(replace(t1.zip_cd,chr(13),''),chr(10),'')  -- 邮编
    ,replace(replace(t1.sys_prtcptr_bigamt_bank_no,chr(13),''),chr(10),'')  -- 系统参与者大额行号
    ,replace(replace(t1.sys_prtcptr_bigamt_bank_name,chr(13),''),chr(10),'')  -- 系统参与者大额行名
    ,replace(replace(t1.ele_bill_agent_bigamt_bank_no,chr(13),''),chr(10),'')  -- 电票代理行大额行号
    ,replace(replace(t1.ele_bill_agent_bigamt_acct_num,chr(13),''),chr(10),'')  -- 电票代理行大额账号
    ,replace(replace(t1.udtake_org_cd,chr(13),''),chr(10),'')  -- 承接机构代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.pty_cpes_mem t1    --票交所会员
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'pty_cpes_mem',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);