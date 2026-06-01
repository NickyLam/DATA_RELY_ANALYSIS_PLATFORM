/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_cpes_mem_bdmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_cpes_mem_bdmsf1_tm purge;
drop table ${iml_schema}.pty_cpes_mem_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_cpes_mem add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_cpes_mem modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_cpes_mem_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cpes_mem partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cpes_mem_bdmsf1_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,mem_id -- 会员编号
    ,mem_cd -- 会员代码
    ,mem_org_cd -- 会员机构代码
    ,mem_org_id -- 会员机构编号
    ,org_cate_cd -- 机构类别代码
    ,org_lev_cd -- 机构级别代码
    ,org_cn_fname -- 机构中文全称
    ,org_en_fname -- 机构英文全称
    ,org_cn_abbr -- 机构中文简称
    ,org_en_abbr -- 机构英文简称
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,dist_cd -- 行政区划代码
    ,lp_lev_cd -- 法人级别代码
    ,org_hibchy_cd -- 机构层级代码
    ,prod_valid_dt -- 产品有效日期
    ,prod_invalid_dt -- 产品失效日期
    ,org_status_cd -- 机构状态代码
    ,org_intnal_acct_name -- 机构内部账户名称
    ,org_intnal_acct_num -- 机构内部账户账号
    ,tran_acct_num -- 交易账号
    ,tran_acct_status_cd -- 交易账户状态代码
    ,trust_acct_num -- 托管账号
    ,trust_acct_status_cd -- 托管账户状态代码
    ,cpes_cap_acct_num -- 票交所资金账户账号
    ,cpes_cap_acct_status_cd -- 票交所资金账户状态代码
    ,legal_rep_or_princ -- 法定代表人或负责人
    ,wdraw_acct_lg_pay_sys_bank_no -- 出金账户开户行大额支付系统行号
    ,wdraw_acct_name -- 出金账户名称
    ,wdraw_acct_num -- 出金账户账号
    ,rgst_cap -- 注册资本
    ,addr -- 地址
    ,cotas -- 联系人
    ,phone -- 联系电话
    ,fax -- 传真
    ,zip_cd -- 邮编
    ,sys_prtcptr_bigamt_bank_no -- 系统参与者大额行号
    ,sys_prtcptr_bigamt_bank_name -- 系统参与者大额行名
    ,ele_bill_agent_bigamt_bank_no -- 电票代理行大额行号
    ,ele_bill_agent_bigamt_acct_num -- 电票代理行大额账号
    ,udtake_org_cd -- 承接机构代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cpes_mem
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_cpes_mem_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_cpes_mem partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_mem_brh_info-
insert into ${iml_schema}.pty_cpes_mem_bdmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,mem_id -- 会员编号
    ,mem_cd -- 会员代码
    ,mem_org_cd -- 会员机构代码
    ,mem_org_id -- 会员机构编号
    ,org_cate_cd -- 机构类别代码
    ,org_lev_cd -- 机构级别代码
    ,org_cn_fname -- 机构中文全称
    ,org_en_fname -- 机构英文全称
    ,org_cn_abbr -- 机构中文简称
    ,org_en_abbr -- 机构英文简称
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,dist_cd -- 行政区划代码
    ,lp_lev_cd -- 法人级别代码
    ,org_hibchy_cd -- 机构层级代码
    ,prod_valid_dt -- 产品有效日期
    ,prod_invalid_dt -- 产品失效日期
    ,org_status_cd -- 机构状态代码
    ,org_intnal_acct_name -- 机构内部账户名称
    ,org_intnal_acct_num -- 机构内部账户账号
    ,tran_acct_num -- 交易账号
    ,tran_acct_status_cd -- 交易账户状态代码
    ,trust_acct_num -- 托管账号
    ,trust_acct_status_cd -- 托管账户状态代码
    ,cpes_cap_acct_num -- 票交所资金账户账号
    ,cpes_cap_acct_status_cd -- 票交所资金账户状态代码
    ,legal_rep_or_princ -- 法定代表人或负责人
    ,wdraw_acct_lg_pay_sys_bank_no -- 出金账户开户行大额支付系统行号
    ,wdraw_acct_name -- 出金账户名称
    ,wdraw_acct_num -- 出金账户账号
    ,rgst_cap -- 注册资本
    ,addr -- 地址
    ,cotas -- 联系人
    ,phone -- 联系电话
    ,fax -- 传真
    ,zip_cd -- 邮编
    ,sys_prtcptr_bigamt_bank_no -- 系统参与者大额行号
    ,sys_prtcptr_bigamt_bank_name -- 系统参与者大额行名
    ,ele_bill_agent_bigamt_bank_no -- 电票代理行大额行号
    ,ele_bill_agent_bigamt_acct_num -- 电票代理行大额账号
    ,udtake_org_cd -- 承接机构代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.ID -- 会员编号
    ,P1.MEM_NO -- 会员代码
    ,P1.BRH_NO -- 会员机构代码
    ,P1.BRH_CODE -- 会员机构编号
    ,NVL(TRIM(P1.BRH_TYPE ),'0') -- 机构类别代码
    ,NVL(TRIM(P1.BRH_CLASS),'000') -- 机构级别代码
    ,P1.BRH_ZH_FULL_NAME -- 机构中文全称
    ,P1.BRH_EN_FULL_NAME -- 机构英文全称
    ,P1.BRH_ZH_SHORT_NAME -- 机构中文简称
    ,P1.BRH_EN_SHORT_NAME -- 机构英文简称
    ,P1.SOCIAL_CREDIT_NO -- 统一社会信用代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PROVINCE_NO END -- 行政区划代码
    ,NVL(TRIM(P1.BR_CORP_CLASS ),'-') -- 法人级别代码
    ,P1.BRH_LEVEL -- 机构层级代码
    ,${iml_schema}.DATEFORMAT_MAX2(P1.PRO_EFFECT_DATE) -- 产品有效日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.PRO_EXPIRE_DATE) -- 产品失效日期
    ,NVL(TRIM(P1.BRH_STATUS ),'-') -- 机构状态代码
    ,P1.BRH_ACCT_NAME -- 机构内部账户名称
    ,P1.BRH_ACCT_NO -- 机构内部账户账号
    ,P1.TXN_ACCT_NO -- 交易账号
    ,NVL(TRIM(P1.TXN_ACCT_STATUS ),'-') -- 交易账户状态代码
    ,P1.REG_ACCT_NO -- 托管账号
    ,NVL(TRIM(P1.REG_ACCT_STATUS ),'-') -- 托管账户状态代码
    ,P1.CAP_ACCT_NO -- 票交所资金账户账号
    ,NVL(TRIM(P1.CAP_ACCT_STATUS ),'-') -- 票交所资金账户状态代码
    ,P1.CORP_REPRESENCE -- 法定代表人或负责人
    ,P1.WITHDRAW_BANK_NO -- 出金账户开户行大额支付系统行号
    ,P1.WITHDRAW_ACCT_NAME -- 出金账户名称
    ,P1.WITHDRAW_ACCT_NO -- 出金账户账号
    ,P1.REGISTERED_CAPITAL -- 注册资本
    ,P1.ADRESS -- 地址
    ,P1.ATTN -- 联系人
    ,P1.TEL -- 联系电话
    ,P1.FAX_CODE -- 传真
    ,P1.POST_CODE -- 邮编
    ,P1.UBANK_NO -- 系统参与者大额行号
    ,P1.UBANK_NAME -- 系统参与者大额行名
    ,P1.AGENCY_UBANK_NO -- 电票代理行大额行号
    ,P1.AGENCY_UBANK_ACCT -- 电票代理行大额账号
    ,P1.RECEPT_BRH_ID -- 承接机构代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_mem_brh_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_mem_brh_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PROVINCE_NO = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_MEM_BRH_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'PROVINCE_NO'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_CPES_MEM'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'DIST_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_cpes_mem_bdmsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.pty_cpes_mem_bdmsf1_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,mem_id -- 会员编号
    ,mem_cd -- 会员代码
    ,mem_org_cd -- 会员机构代码
    ,mem_org_id -- 会员机构编号
    ,org_cate_cd -- 机构类别代码
    ,org_lev_cd -- 机构级别代码
    ,org_cn_fname -- 机构中文全称
    ,org_en_fname -- 机构英文全称
    ,org_cn_abbr -- 机构中文简称
    ,org_en_abbr -- 机构英文简称
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,dist_cd -- 行政区划代码
    ,lp_lev_cd -- 法人级别代码
    ,org_hibchy_cd -- 机构层级代码
    ,prod_valid_dt -- 产品有效日期
    ,prod_invalid_dt -- 产品失效日期
    ,org_status_cd -- 机构状态代码
    ,org_intnal_acct_name -- 机构内部账户名称
    ,org_intnal_acct_num -- 机构内部账户账号
    ,tran_acct_num -- 交易账号
    ,tran_acct_status_cd -- 交易账户状态代码
    ,trust_acct_num -- 托管账号
    ,trust_acct_status_cd -- 托管账户状态代码
    ,cpes_cap_acct_num -- 票交所资金账户账号
    ,cpes_cap_acct_status_cd -- 票交所资金账户状态代码
    ,legal_rep_or_princ -- 法定代表人或负责人
    ,wdraw_acct_lg_pay_sys_bank_no -- 出金账户开户行大额支付系统行号
    ,wdraw_acct_name -- 出金账户名称
    ,wdraw_acct_num -- 出金账户账号
    ,rgst_cap -- 注册资本
    ,addr -- 地址
    ,cotas -- 联系人
    ,phone -- 联系电话
    ,fax -- 传真
    ,zip_cd -- 邮编
    ,sys_prtcptr_bigamt_bank_no -- 系统参与者大额行号
    ,sys_prtcptr_bigamt_bank_name -- 系统参与者大额行名
    ,ele_bill_agent_bigamt_bank_no -- 电票代理行大额行号
    ,ele_bill_agent_bigamt_acct_num -- 电票代理行大额账号
    ,udtake_org_cd -- 承接机构代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.mem_id, o.mem_id) as mem_id -- 会员编号
    ,nvl(n.mem_cd, o.mem_cd) as mem_cd -- 会员代码
    ,nvl(n.mem_org_cd, o.mem_org_cd) as mem_org_cd -- 会员机构代码
    ,nvl(n.mem_org_id, o.mem_org_id) as mem_org_id -- 会员机构编号
    ,nvl(n.org_cate_cd, o.org_cate_cd) as org_cate_cd -- 机构类别代码
    ,nvl(n.org_lev_cd, o.org_lev_cd) as org_lev_cd -- 机构级别代码
    ,nvl(n.org_cn_fname, o.org_cn_fname) as org_cn_fname -- 机构中文全称
    ,nvl(n.org_en_fname, o.org_en_fname) as org_en_fname -- 机构英文全称
    ,nvl(n.org_cn_abbr, o.org_cn_abbr) as org_cn_abbr -- 机构中文简称
    ,nvl(n.org_en_abbr, o.org_en_abbr) as org_en_abbr -- 机构英文简称
    ,nvl(n.unify_soci_crdt_cd, o.unify_soci_crdt_cd) as unify_soci_crdt_cd -- 统一社会信用代码
    ,nvl(n.dist_cd, o.dist_cd) as dist_cd -- 行政区划代码
    ,nvl(n.lp_lev_cd, o.lp_lev_cd) as lp_lev_cd -- 法人级别代码
    ,nvl(n.org_hibchy_cd, o.org_hibchy_cd) as org_hibchy_cd -- 机构层级代码
    ,nvl(n.prod_valid_dt, o.prod_valid_dt) as prod_valid_dt -- 产品有效日期
    ,nvl(n.prod_invalid_dt, o.prod_invalid_dt) as prod_invalid_dt -- 产品失效日期
    ,nvl(n.org_status_cd, o.org_status_cd) as org_status_cd -- 机构状态代码
    ,nvl(n.org_intnal_acct_name, o.org_intnal_acct_name) as org_intnal_acct_name -- 机构内部账户名称
    ,nvl(n.org_intnal_acct_num, o.org_intnal_acct_num) as org_intnal_acct_num -- 机构内部账户账号
    ,nvl(n.tran_acct_num, o.tran_acct_num) as tran_acct_num -- 交易账号
    ,nvl(n.tran_acct_status_cd, o.tran_acct_status_cd) as tran_acct_status_cd -- 交易账户状态代码
    ,nvl(n.trust_acct_num, o.trust_acct_num) as trust_acct_num -- 托管账号
    ,nvl(n.trust_acct_status_cd, o.trust_acct_status_cd) as trust_acct_status_cd -- 托管账户状态代码
    ,nvl(n.cpes_cap_acct_num, o.cpes_cap_acct_num) as cpes_cap_acct_num -- 票交所资金账户账号
    ,nvl(n.cpes_cap_acct_status_cd, o.cpes_cap_acct_status_cd) as cpes_cap_acct_status_cd -- 票交所资金账户状态代码
    ,nvl(n.legal_rep_or_princ, o.legal_rep_or_princ) as legal_rep_or_princ -- 法定代表人或负责人
    ,nvl(n.wdraw_acct_lg_pay_sys_bank_no, o.wdraw_acct_lg_pay_sys_bank_no) as wdraw_acct_lg_pay_sys_bank_no -- 出金账户开户行大额支付系统行号
    ,nvl(n.wdraw_acct_name, o.wdraw_acct_name) as wdraw_acct_name -- 出金账户名称
    ,nvl(n.wdraw_acct_num, o.wdraw_acct_num) as wdraw_acct_num -- 出金账户账号
    ,nvl(n.rgst_cap, o.rgst_cap) as rgst_cap -- 注册资本
    ,nvl(n.addr, o.addr) as addr -- 地址
    ,nvl(n.cotas, o.cotas) as cotas -- 联系人
    ,nvl(n.phone, o.phone) as phone -- 联系电话
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.zip_cd, o.zip_cd) as zip_cd -- 邮编
    ,nvl(n.sys_prtcptr_bigamt_bank_no, o.sys_prtcptr_bigamt_bank_no) as sys_prtcptr_bigamt_bank_no -- 系统参与者大额行号
    ,nvl(n.sys_prtcptr_bigamt_bank_name, o.sys_prtcptr_bigamt_bank_name) as sys_prtcptr_bigamt_bank_name -- 系统参与者大额行名
    ,nvl(n.ele_bill_agent_bigamt_bank_no, o.ele_bill_agent_bigamt_bank_no) as ele_bill_agent_bigamt_bank_no -- 电票代理行大额行号
    ,nvl(n.ele_bill_agent_bigamt_acct_num, o.ele_bill_agent_bigamt_acct_num) as ele_bill_agent_bigamt_acct_num -- 电票代理行大额账号
    ,nvl(n.udtake_org_cd, o.udtake_org_cd) as udtake_org_cd -- 承接机构代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.party_id is null
                and o.lp_id is null
            ) or (
                o.mem_id <> n.mem_id
                or o.mem_cd <> n.mem_cd
                or o.mem_org_cd <> n.mem_org_cd
                or o.mem_org_id <> n.mem_org_id
                or o.org_cate_cd <> n.org_cate_cd
                or o.org_lev_cd <> n.org_lev_cd
                or o.org_cn_fname <> n.org_cn_fname
                or o.org_en_fname <> n.org_en_fname
                or o.org_cn_abbr <> n.org_cn_abbr
                or o.org_en_abbr <> n.org_en_abbr
                or o.unify_soci_crdt_cd <> n.unify_soci_crdt_cd
                or o.dist_cd <> n.dist_cd
                or o.lp_lev_cd <> n.lp_lev_cd
                or o.org_hibchy_cd <> n.org_hibchy_cd
                or o.prod_valid_dt <> n.prod_valid_dt
                or o.prod_invalid_dt <> n.prod_invalid_dt
                or o.org_status_cd <> n.org_status_cd
                or o.org_intnal_acct_name <> n.org_intnal_acct_name
                or o.org_intnal_acct_num <> n.org_intnal_acct_num
                or o.tran_acct_num <> n.tran_acct_num
                or o.tran_acct_status_cd <> n.tran_acct_status_cd
                or o.trust_acct_num <> n.trust_acct_num
                or o.trust_acct_status_cd <> n.trust_acct_status_cd
                or o.cpes_cap_acct_num <> n.cpes_cap_acct_num
                or o.cpes_cap_acct_status_cd <> n.cpes_cap_acct_status_cd
                or o.legal_rep_or_princ <> n.legal_rep_or_princ
                or o.wdraw_acct_lg_pay_sys_bank_no <> n.wdraw_acct_lg_pay_sys_bank_no
                or o.wdraw_acct_name <> n.wdraw_acct_name
                or o.wdraw_acct_num <> n.wdraw_acct_num
                or o.rgst_cap <> n.rgst_cap
                or o.addr <> n.addr
                or o.cotas <> n.cotas
                or o.phone <> n.phone
                or o.fax <> n.fax
                or o.zip_cd <> n.zip_cd
                or o.sys_prtcptr_bigamt_bank_no <> n.sys_prtcptr_bigamt_bank_no
                or o.sys_prtcptr_bigamt_bank_name <> n.sys_prtcptr_bigamt_bank_name
                or o.ele_bill_agent_bigamt_bank_no <> n.ele_bill_agent_bigamt_bank_no
                or o.ele_bill_agent_bigamt_acct_num <> n.ele_bill_agent_bigamt_acct_num
                or o.udtake_org_cd <> n.udtake_org_cd
            ) or (
                 case when (
                           n.party_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.party_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cpes_mem_bdmsf1_tm n
    full join ${iml_schema}.pty_cpes_mem_bdmsf1_bk o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_cpes_mem truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_cpes_mem exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.pty_cpes_mem_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_cpes_mem drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_cpes_mem to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_cpes_mem_bdmsf1_tm purge;
drop table ${iml_schema}.pty_cpes_mem_bdmsf1_ex purge;
drop table ${iml_schema}.pty_cpes_mem_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_cpes_mem', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);