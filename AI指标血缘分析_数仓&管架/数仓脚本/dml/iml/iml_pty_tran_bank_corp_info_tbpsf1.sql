/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_tran_bank_corp_info_tbpsf1
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
drop table ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_tm purge;
drop table ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_tran_bank_corp_info add partition p_tbpsf1 values ('tbpsf1')(
        subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_tran_bank_corp_info modify partition p_tbpsf1
    add subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_tran_bank_corp_info partition for ('tbpsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cust_cn_name -- 客户中文名称
    ,cust_en_name -- 客户英文名称
    ,cust_type_cd -- 客户类型代码
    ,edit_flg -- 版本标志
    ,corp_addr -- 企业地址
    ,charge_acct_num -- 收费账号
    ,curr_cd -- 币种代码
    ,zip_cd -- 邮政编码
    ,tel_num -- 电话号码
    ,fax -- 传真
    ,e_mail -- 电子邮箱
    ,open_acct_tm -- 开户时间
    ,final_update_tm -- 最后更新时间
    ,acct_status_cd -- 账户状态代码
    ,status_remark -- 状态备注
    ,orgnz_id -- 组织机构编号
    ,legal_rep_name -- 法人代表名称
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,lp_tel_num -- 法人电话号码
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_brch_id -- 开户分行编号
    ,open_acct_brac_id -- 开户网点编号
    ,bus_belong_brac_id -- 业务归属网点编号
    ,open_acct_operr_id -- 开户操作员编号
    ,cash_ctrl_flg -- 现金控制标志
    ,lp_cert_exp_dt -- 法人证件到期日期
    ,sup_chain_sys_flg -- 供应链系统标志
    ,sign_yqt_flg -- 签约银企通标志
    ,sign_yqt_tm -- 签约银企通时间
    ,oa_wrtoff_tm -- OA注销时间
    ,init_oa_id -- 原OA编号
    ,oa_reim_rela_acct -- OA报销关联账户
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,group_cust_flg -- 集团客户标志
    ,sign_chn_cd -- 签约渠道代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_tran_bank_corp_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_tran_bank_corp_info partition for ('tbpsf1') where 0=1;

-- 2.1 insert data to tm table
-- tbps_cpr_cst_inf-
insert into ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cust_cn_name -- 客户中文名称
    ,cust_en_name -- 客户英文名称
    ,cust_type_cd -- 客户类型代码
    ,edit_flg -- 版本标志
    ,corp_addr -- 企业地址
    ,charge_acct_num -- 收费账号
    ,curr_cd -- 币种代码
    ,zip_cd -- 邮政编码
    ,tel_num -- 电话号码
    ,fax -- 传真
    ,e_mail -- 电子邮箱
    ,open_acct_tm -- 开户时间
    ,final_update_tm -- 最后更新时间
    ,acct_status_cd -- 账户状态代码
    ,status_remark -- 状态备注
    ,orgnz_id -- 组织机构编号
    ,legal_rep_name -- 法人代表名称
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,lp_tel_num -- 法人电话号码
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_brch_id -- 开户分行编号
    ,open_acct_brac_id -- 开户网点编号
    ,bus_belong_brac_id -- 业务归属网点编号
    ,open_acct_operr_id -- 开户操作员编号
    ,cash_ctrl_flg -- 现金控制标志
    ,lp_cert_exp_dt -- 法人证件到期日期
    ,sup_chain_sys_flg -- 供应链系统标志
    ,sign_yqt_flg -- 签约银企通标志
    ,sign_yqt_tm -- 签约银企通时间
    ,oa_wrtoff_tm -- OA注销时间
    ,init_oa_id -- 原OA编号
    ,oa_reim_rela_acct -- OA报销关联账户
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,group_cust_flg -- 集团客户标志
    ,sign_chn_cd -- 签约渠道代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CIF_ECIFNO -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.CIF_NAMECN -- 客户中文名称
    ,P1.CIF_NAMEEN -- 客户英文名称
    ,P1.CIF_CUSTFLAG -- 客户类型代码
    ,P1.CIF_SRCLEVEL -- 版本标志
    ,P1.CIF_ADDRESS -- 企业地址
    ,P1.CIF_FEEACCOUNT -- 收费账号
    ,NVL(TRIM(p1.CIF_FEECURRENCY),'CNY') -- 币种代码
    ,P1.CIF_ZIPCODE -- 邮政编码
    ,P1.CIF_PHONE -- 电话号码
    ,P1.CIF_FAX -- 传真
    ,P1.CIF_EMAIL -- 电子邮箱
    ,case when trim (CIF_OPENTIME) is null 
         then to_timestamp('0001-01-01','yyyy-mm-dd')
           else to_timestamp(substr(P1.CIF_OPENTIME,1,4)||'-'||substr(P1.CIF_OPENTIME,5,2)||'-'||substr(P1.CIF_OPENTIME,7,2)||' '||nvl(substr(P1.CIF_OPENTIME,9,2),'00')||':'||nvl(substr(P1.CIF_OPENTIME,11,2),'00')||':'||nvl(substr(P1.CIF_OPENTIME,13,2),'00'),'yyyy-mm-dd hh24:mi:ss.ff6')
        end -- 开户时间
    ,case when trim (CIF_LASTUPDATETIME) is null 
         then to_timestamp('2099-12-31','yyyy-mm-dd')
           else to_timestamp(substr(P1.CIF_LASTUPDATETIME,1,4)||'-'||substr(P1.CIF_LASTUPDATETIME,5,2)||'-'||substr(P1.CIF_LASTUPDATETIME,7,2)||' '||nvl(substr(P1.CIF_LASTUPDATETIME,9,2),'00')||':'||nvl(substr(P1.CIF_LASTUPDATETIME,11,2),'00')||':'||nvl(substr(P1.CIF_LASTUPDATETIME,13,2),'00'),'yyyy-mm-dd hh24:mi:ss.ff6')
           end -- 最后更新时间
    ,P1.CIF_STT -- 账户状态代码
    ,P1.CIF_REMARK -- 状态备注
    ,P1.CIF_ORGID -- 组织机构编号
    ,P1.CIF_LEGALNAME -- 法人代表名称
    ,P1.CIF_LEGALCERTTYPE -- 法人证件类型代码
    ,P1.CIF_LEGALCERTNO -- 法人证件号码
    ,P1.CIF_LEGALPHONE -- 法人电话号码
    ,P1.CIF_RMCODE -- 客户经理编号
    ,P1.CIF_OPENBRANCH -- 开户分行编号
    ,P1.CIF_OPENDEPT -- 开户网点编号
    ,P1.CIF_BUSINESSNODE -- 业务归属网点编号
    ,P1.CIF_OPENTELLER -- 开户操作员编号
    ,P1.CIF_CASHCONTROLFLAG -- 现金控制标志
    ,${iml_schema}.DATEFORMAT_MAX(P1.CIF_LEGALCARDENDDATE) -- 法人证件到期日期
    ,P1.SUPPLYCHAINFLAG -- 供应链系统标志
    ,P1.CIF_MOBILEBANK_OPEN -- 签约银企通标志
    ,case when trim (CIF_MOBILEBANK_OPENTIME) is null 
         then to_timestamp('0001-01-01','yyyy-mm-dd')
           else to_timestamp(substr(P1.CIF_MOBILEBANK_OPENTIME,1,4)||'-'||substr(P1.CIF_MOBILEBANK_OPENTIME,5,2)||'-'||substr(P1.CIF_MOBILEBANK_OPENTIME,7,2)||' '||nvl(substr(P1.CIF_MOBILEBANK_OPENTIME,9,2),'00')||':'||nvl(substr(P1.CIF_MOBILEBANK_OPENTIME,11,2),'00')||':'||nvl(substr(P1.CIF_MOBILEBANK_OPENTIME,13,2),'00'),'yyyy-mm-dd hh24:mi:ss.ff6') 
             end -- 签约银企通时间
    ,case when trim (CIF_CANCELOATIME) is null 
         then to_timestamp('2099-12-31','yyyy-mm-dd')
           else to_timestamp(substr(P1.CIF_CANCELOATIME,1,4)||'-'||substr(P1.CIF_CANCELOATIME,5,2)||'-'||substr(P1.CIF_CANCELOATIME,7,2)||' '||nvl(substr(P1.CIF_CANCELOATIME,9,2),'00')||':'||nvl(substr(P1.CIF_CANCELOATIME,11,2),'00')||':'||nvl(substr(P1.CIF_CANCELOATIME,13,2),'00'),'yyyy-mm-dd hh24:mi:ss.ff6')-- OA注销时间
          end -- OA注销时间
    ,P1.CIF_OLDAONO -- 原OA编号
    ,P1.CIF_EXPENSE_ACCOUNT -- OA报销关联账户
    ,NVL(TRIM(P1.CIF_CTFTYP),'0000') -- 证件类型代码
    ,P1.CIF_CTFNO -- 证件号码
    ,P1.CIF_GROUPFLAG -- 集团客户标志
    ,P1.CIF_OPENCHANNEL -- 签约渠道代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tbps_cpr_cst_inf' -- 源表名称
    ,'tbpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tbps_cpr_cst_inf p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_tm 
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
insert /*+ append */ into ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cust_cn_name -- 客户中文名称
    ,cust_en_name -- 客户英文名称
    ,cust_type_cd -- 客户类型代码
    ,edit_flg -- 版本标志
    ,corp_addr -- 企业地址
    ,charge_acct_num -- 收费账号
    ,curr_cd -- 币种代码
    ,zip_cd -- 邮政编码
    ,tel_num -- 电话号码
    ,fax -- 传真
    ,e_mail -- 电子邮箱
    ,open_acct_tm -- 开户时间
    ,final_update_tm -- 最后更新时间
    ,acct_status_cd -- 账户状态代码
    ,status_remark -- 状态备注
    ,orgnz_id -- 组织机构编号
    ,legal_rep_name -- 法人代表名称
    ,lp_cert_type_cd -- 法人证件类型代码
    ,lp_cert_no -- 法人证件号码
    ,lp_tel_num -- 法人电话号码
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_brch_id -- 开户分行编号
    ,open_acct_brac_id -- 开户网点编号
    ,bus_belong_brac_id -- 业务归属网点编号
    ,open_acct_operr_id -- 开户操作员编号
    ,cash_ctrl_flg -- 现金控制标志
    ,lp_cert_exp_dt -- 法人证件到期日期
    ,sup_chain_sys_flg -- 供应链系统标志
    ,sign_yqt_flg -- 签约银企通标志
    ,sign_yqt_tm -- 签约银企通时间
    ,oa_wrtoff_tm -- OA注销时间
    ,init_oa_id -- 原OA编号
    ,oa_reim_rela_acct -- OA报销关联账户
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,group_cust_flg -- 集团客户标志
    ,sign_chn_cd -- 签约渠道代码
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
    ,nvl(n.cust_cn_name, o.cust_cn_name) as cust_cn_name -- 客户中文名称
    ,nvl(n.cust_en_name, o.cust_en_name) as cust_en_name -- 客户英文名称
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.edit_flg, o.edit_flg) as edit_flg -- 版本标志
    ,nvl(n.corp_addr, o.corp_addr) as corp_addr -- 企业地址
    ,nvl(n.charge_acct_num, o.charge_acct_num) as charge_acct_num -- 收费账号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.zip_cd, o.zip_cd) as zip_cd -- 邮政编码
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.e_mail, o.e_mail) as e_mail -- 电子邮箱
    ,nvl(n.open_acct_tm, o.open_acct_tm) as open_acct_tm -- 开户时间
    ,nvl(n.final_update_tm, o.final_update_tm) as final_update_tm -- 最后更新时间
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.status_remark, o.status_remark) as status_remark -- 状态备注
    ,nvl(n.orgnz_id, o.orgnz_id) as orgnz_id -- 组织机构编号
    ,nvl(n.legal_rep_name, o.legal_rep_name) as legal_rep_name -- 法人代表名称
    ,nvl(n.lp_cert_type_cd, o.lp_cert_type_cd) as lp_cert_type_cd -- 法人证件类型代码
    ,nvl(n.lp_cert_no, o.lp_cert_no) as lp_cert_no -- 法人证件号码
    ,nvl(n.lp_tel_num, o.lp_tel_num) as lp_tel_num -- 法人电话号码
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.open_acct_brch_id, o.open_acct_brch_id) as open_acct_brch_id -- 开户分行编号
    ,nvl(n.open_acct_brac_id, o.open_acct_brac_id) as open_acct_brac_id -- 开户网点编号
    ,nvl(n.bus_belong_brac_id, o.bus_belong_brac_id) as bus_belong_brac_id -- 业务归属网点编号
    ,nvl(n.open_acct_operr_id, o.open_acct_operr_id) as open_acct_operr_id -- 开户操作员编号
    ,nvl(n.cash_ctrl_flg, o.cash_ctrl_flg) as cash_ctrl_flg -- 现金控制标志
    ,nvl(n.lp_cert_exp_dt, o.lp_cert_exp_dt) as lp_cert_exp_dt -- 法人证件到期日期
    ,nvl(n.sup_chain_sys_flg, o.sup_chain_sys_flg) as sup_chain_sys_flg -- 供应链系统标志
    ,nvl(n.sign_yqt_flg, o.sign_yqt_flg) as sign_yqt_flg -- 签约银企通标志
    ,nvl(n.sign_yqt_tm, o.sign_yqt_tm) as sign_yqt_tm -- 签约银企通时间
    ,nvl(n.oa_wrtoff_tm, o.oa_wrtoff_tm) as oa_wrtoff_tm -- OA注销时间
    ,nvl(n.init_oa_id, o.init_oa_id) as init_oa_id -- 原OA编号
    ,nvl(n.oa_reim_rela_acct, o.oa_reim_rela_acct) as oa_reim_rela_acct -- OA报销关联账户
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.group_cust_flg, o.group_cust_flg) as group_cust_flg -- 集团客户标志
    ,nvl(n.sign_chn_cd, o.sign_chn_cd) as sign_chn_cd -- 签约渠道代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.party_id is null
                and o.lp_id is null
            ) or (
                o.cust_cn_name <> n.cust_cn_name
                or o.cust_en_name <> n.cust_en_name
                or o.cust_type_cd <> n.cust_type_cd
                or o.edit_flg <> n.edit_flg
                or o.corp_addr <> n.corp_addr
                or o.charge_acct_num <> n.charge_acct_num
                or o.curr_cd <> n.curr_cd
                or o.zip_cd <> n.zip_cd
                or o.tel_num <> n.tel_num
                or o.fax <> n.fax
                or o.e_mail <> n.e_mail
                or o.open_acct_tm <> n.open_acct_tm
                or o.final_update_tm <> n.final_update_tm
                or o.acct_status_cd <> n.acct_status_cd
                or o.status_remark <> n.status_remark
                or o.orgnz_id <> n.orgnz_id
                or o.legal_rep_name <> n.legal_rep_name
                or o.lp_cert_type_cd <> n.lp_cert_type_cd
                or o.lp_cert_no <> n.lp_cert_no
                or o.lp_tel_num <> n.lp_tel_num
                or o.cust_mgr_id <> n.cust_mgr_id
                or o.open_acct_brch_id <> n.open_acct_brch_id
                or o.open_acct_brac_id <> n.open_acct_brac_id
                or o.bus_belong_brac_id <> n.bus_belong_brac_id
                or o.open_acct_operr_id <> n.open_acct_operr_id
                or o.cash_ctrl_flg <> n.cash_ctrl_flg
                or o.lp_cert_exp_dt <> n.lp_cert_exp_dt
                or o.sup_chain_sys_flg <> n.sup_chain_sys_flg
                or o.sign_yqt_flg <> n.sign_yqt_flg
                or o.sign_yqt_tm <> n.sign_yqt_tm
                or o.oa_wrtoff_tm <> n.oa_wrtoff_tm
                or o.init_oa_id <> n.init_oa_id
                or o.oa_reim_rela_acct <> n.oa_reim_rela_acct
                or o.cert_type_cd <> n.cert_type_cd
                or o.cert_no <> n.cert_no
                or o.group_cust_flg <> n.group_cust_flg
                or o.sign_chn_cd <> n.sign_chn_cd
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
from ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_tm n
    full join ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_bk o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_tran_bank_corp_info truncate partition for ('tbpsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_tran_bank_corp_info exchange subpartition p_tbpsf1_${batch_date} with table ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_tran_bank_corp_info drop subpartition p_tbpsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_tran_bank_corp_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_tm purge;
drop table ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_ex purge;
drop table ${iml_schema}.pty_tran_bank_corp_info_tbpsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_tran_bank_corp_info', partname => 'p_tbpsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);