/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_cpes_mem
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_pty_cpes_mem drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_cpes_mem add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_cpes_mem (
etl_dt  --ETL处理日期
,mem_id  --会员编号
,mem_cd  --会员代码
,mem_org_cd  --会员机构代码
,mem_org_id  --会员机构编号
,org_cate_cd  --机构类别代码
,org_lev_cd  --机构级别代码
,org_cn_fname  --机构中文全称
,org_en_fname  --机构英文全称
,org_cn_abbr  --机构中文简称
,org_en_abbr  --机构英文简称
,unify_soci_crdt_cd  --统一社会信用代码
,dist_cd  --行政区划代码
,lp_lev_cd  --法人级别代码
,org_hibchy_cd  --机构层级代码
,prod_valid_dt  --产品有效日期
,prod_invalid_dt  --产品失效日期
,org_status_cd  --机构状态代码
,org_intnal_acct_name  --机构内部账户名称
,org_intnal_acct_num  --机构内部账户账号
,tran_acct_num  --交易账号
,tran_acct_status_cd  --交易账户状态代码
,trust_acct_num  --托管账号
,trust_acct_status_cd  --托管账户状态代码
,cpes_cap_acct_num  --票交所资金账户账号
,cpes_cap_acct_status_cd  --票交所资金账户状态代码
,legal_rep_or_princ  --法定代表人名称
,wdraw_acct_lg_pay_sys_bank_no  --出金账户开户行大额支付系统行号
,wdraw_acct_name  --出金账户名称
,wdraw_acct_num  --出金账户账号
,rgst_cap  --注册资本
,addr  --地址
,cotas  --联系人
,phone  --联系电话
,fax  --传真
,zip_cd  --邮编
,sys_prtcptr_bigamt_bank_no  --系统参与者大额行号
,sys_prtcptr_bigamt_bank_name  --系统参与者大额行名
,ele_bill_agent_bigamt_bank_no  --电票代理行大额行号
,ele_bill_agent_bigamt_acct_num  --电票代理行大额账号
,udtake_org_cd  --承接机构代码
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,party_id  --当事人编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.mem_id,chr(13),''),chr(10),'') as mem_id --会员编号
,replace(replace(t1.mem_cd,chr(13),''),chr(10),'') as mem_cd --会员代码
,replace(replace(t1.mem_org_cd,chr(13),''),chr(10),'') as mem_org_cd --会员机构代码
,replace(replace(t1.mem_org_id,chr(13),''),chr(10),'') as mem_org_id --会员机构编号
,replace(replace(t1.org_cate_cd,chr(13),''),chr(10),'') as org_cate_cd --机构类别代码
,replace(replace(t1.org_lev_cd,chr(13),''),chr(10),'') as org_lev_cd --机构级别代码
,replace(replace(t1.org_cn_fname,chr(13),''),chr(10),'') as org_cn_fname --机构中文全称
,replace(replace(t1.org_en_fname,chr(13),''),chr(10),'') as org_en_fname --机构英文全称
,replace(replace(t1.org_cn_abbr,chr(13),''),chr(10),'') as org_cn_abbr --机构中文简称
,replace(replace(t1.org_en_abbr,chr(13),''),chr(10),'') as org_en_abbr --机构英文简称
,replace(replace(t1.unify_soci_crdt_cd,chr(13),''),chr(10),'') as unify_soci_crdt_cd --统一社会信用代码
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd --行政区划代码
,replace(replace(t1.lp_lev_cd,chr(13),''),chr(10),'') as lp_lev_cd --法人级别代码
,replace(replace(t1.org_hibchy_cd,chr(13),''),chr(10),'') as org_hibchy_cd --机构层级代码
,t1.prod_valid_dt as prod_valid_dt --产品有效日期
,t1.prod_invalid_dt as prod_invalid_dt --产品失效日期
,replace(replace(t1.org_status_cd,chr(13),''),chr(10),'') as org_status_cd --机构状态代码
,replace(replace(t1.org_intnal_acct_name,chr(13),''),chr(10),'') as org_intnal_acct_name --机构内部账户名称
,replace(replace(t1.org_intnal_acct_num,chr(13),''),chr(10),'') as org_intnal_acct_num --机构内部账户账号
,replace(replace(t1.tran_acct_num,chr(13),''),chr(10),'') as tran_acct_num --交易账号
,replace(replace(t1.tran_acct_status_cd,chr(13),''),chr(10),'') as tran_acct_status_cd --交易账户状态代码
,replace(replace(t1.trust_acct_num,chr(13),''),chr(10),'') as trust_acct_num --托管账号
,replace(replace(t1.trust_acct_status_cd,chr(13),''),chr(10),'') as trust_acct_status_cd --托管账户状态代码
,replace(replace(t1.cpes_cap_acct_num,chr(13),''),chr(10),'') as cpes_cap_acct_num --票交所资金账户账号
,replace(replace(t1.cpes_cap_acct_status_cd,chr(13),''),chr(10),'') as cpes_cap_acct_status_cd --票交所资金账户状态代码
,replace(replace(t1.legal_rep_or_princ,chr(13),''),chr(10),'') as legal_rep_or_princ --法定代表人名称
,replace(replace(t1.wdraw_acct_lg_pay_sys_bank_no,chr(13),''),chr(10),'') as wdraw_acct_lg_pay_sys_bank_no --出金账户开户行大额支付系统行号
,replace(replace(t1.wdraw_acct_name,chr(13),''),chr(10),'') as wdraw_acct_name --出金账户名称
,replace(replace(t1.wdraw_acct_num,chr(13),''),chr(10),'') as wdraw_acct_num --出金账户账号
,t1.rgst_cap as rgst_cap --注册资本
,replace(replace(t1.addr,chr(13),''),chr(10),'') as addr --地址
,replace(replace(t1.cotas,chr(13),''),chr(10),'') as cotas --联系人
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone --联系电话
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax --传真
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd --邮编
,replace(replace(t1.sys_prtcptr_bigamt_bank_no,chr(13),''),chr(10),'') as sys_prtcptr_bigamt_bank_no --系统参与者大额行号
,replace(replace(t1.sys_prtcptr_bigamt_bank_name,chr(13),''),chr(10),'') as sys_prtcptr_bigamt_bank_name --系统参与者大额行名
,replace(replace(t1.ele_bill_agent_bigamt_bank_no,chr(13),''),chr(10),'') as ele_bill_agent_bigamt_bank_no --电票代理行大额行号
,replace(replace(t1.ele_bill_agent_bigamt_acct_num,chr(13),''),chr(10),'') as ele_bill_agent_bigamt_acct_num --电票代理行大额账号
,replace(replace(t1.udtake_org_cd,chr(13),''),chr(10),'') as udtake_org_cd --承接机构代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_cpes_mem t1    --票交所会员
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_cpes_mem',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
