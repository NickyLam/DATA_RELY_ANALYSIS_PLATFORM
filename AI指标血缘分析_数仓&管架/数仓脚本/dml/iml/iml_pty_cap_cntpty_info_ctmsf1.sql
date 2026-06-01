/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_cap_cntpty_info_ctmsf1
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
drop table ${iml_schema}.pty_cap_cntpty_info_ctmsf1_tm purge;
drop table ${iml_schema}.pty_cap_cntpty_info_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_cap_cntpty_info add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_cap_cntpty_info modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_cap_cntpty_info_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cap_cntpty_info partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cap_cntpty_info_ctmsf1_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,dept_id -- 部门编号
    ,cntpty_id -- 交易对手编号
    ,cntpty_abbr -- 交易对手简称
    ,cntpty_fname -- 交易对手全称
    ,cntpty_en_abbr -- 交易对手英文简称
    ,cntpty_en_name -- 交易对手英文名称
    ,elec_cert_name -- 电子证书名称
    ,elec_cert_id -- 电子证书编号
    ,elec_cert_flg -- 电子证书标志
    ,intnal_rating_level_cd -- 内部评级等级代码
    ,cotas_name -- 联系人名称
    ,tel_num -- 电话号码
    ,fax_num -- 传真号码
    ,issuer_flg -- 发行人标志
    ,issuer_id -- 发行人编号
    ,guartor_flg -- 担保人标志
    ,guartor_id -- 担保人编号
    ,fin_inst_flg -- 金融机构标志
    ,trust_org_flg -- 托管机构标志
    ,indus_type_cd -- 行业类型代码
    ,elec_ibank_no -- 电子联行号
    ,pay_bk_bank_no -- 支付行行号
    ,swift_id -- SWIFT编号
    ,cust_id -- 客户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cap_cntpty_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_cap_cntpty_info_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_cap_cntpty_info partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_vs_cptys-
insert into ${iml_schema}.pty_cap_cntpty_info_ctmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,dept_id -- 部门编号
    ,cntpty_id -- 交易对手编号
    ,cntpty_abbr -- 交易对手简称
    ,cntpty_fname -- 交易对手全称
    ,cntpty_en_abbr -- 交易对手英文简称
    ,cntpty_en_name -- 交易对手英文名称
    ,elec_cert_name -- 电子证书名称
    ,elec_cert_id -- 电子证书编号
    ,elec_cert_flg -- 电子证书标志
    ,intnal_rating_level_cd -- 内部评级等级代码
    ,cotas_name -- 联系人名称
    ,tel_num -- 电话号码
    ,fax_num -- 传真号码
    ,issuer_flg -- 发行人标志
    ,issuer_id -- 发行人编号
    ,guartor_flg -- 担保人标志
    ,guartor_id -- 担保人编号
    ,fin_inst_flg -- 金融机构标志
    ,trust_org_flg -- 托管机构标志
    ,indus_type_cd -- 行业类型代码
    ,elec_ibank_no -- 电子联行号
    ,pay_bk_bank_no -- 支付行行号
    ,swift_id -- SWIFT编号
    ,cust_id -- 客户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101002'||TO_CHAR(P1.CPTYS_ID) -- 当事人编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.ASPCLIENT_ID) -- 部门编号
    ,TO_CHAR(P1.CPTYS_ID) -- 交易对手编号
    ,P1.CPTYS_SHORTNAME -- 交易对手简称
    ,P1.CPTYS_NAME -- 交易对手全称
    ,P1.COUNTERPARTY_SHORT_ENAME -- 交易对手英文简称
    ,P1.COUNTERPARTY_ENAME -- 交易对手英文名称
    ,P1.NAME_SRC -- 电子证书名称
    ,P1.KEY_SRC -- 电子证书编号
    ,P1.ISLINK_SRC -- 电子证书标志
    ,P1.RATING_LEVEL -- 内部评级等级代码
    ,P1.CONTACT_NAME -- 联系人名称
    ,P1.TELEPHONE -- 电话号码
    ,P1.FAX -- 传真号码
    ,P1.IS_ISSUER -- 发行人标志
    ,case when IS_ISSUER = '1' then P1.REF_ISSUER_ID else ' ' end -- 发行人编号
    ,P1.IS_GUARANTEE -- 担保人标志
    ,case when IS_GUARANTEE= '1' then P1.REF_ISSUER_ID else ' ' end -- 担保人编号
    ,P1.IS_BANK -- 金融机构标志
    ,P1.IS_CUSTODY -- 托管机构标志
    ,nvl(trim(P1.CUSTOMER_TYPE_CODE),'-') -- 行业类型代码
    ,P1.EX_CODE -- 电子联行号
    ,P1.EX_ACCOUNT -- 支付行行号
    ,P1.SWIFT_CODE -- SWIFT编号
    ,P1.LABEL -- 客户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_cptys' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_cptys p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_cap_cntpty_info_ctmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.pty_cap_cntpty_info_ctmsf1_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,dept_id -- 部门编号
    ,cntpty_id -- 交易对手编号
    ,cntpty_abbr -- 交易对手简称
    ,cntpty_fname -- 交易对手全称
    ,cntpty_en_abbr -- 交易对手英文简称
    ,cntpty_en_name -- 交易对手英文名称
    ,elec_cert_name -- 电子证书名称
    ,elec_cert_id -- 电子证书编号
    ,elec_cert_flg -- 电子证书标志
    ,intnal_rating_level_cd -- 内部评级等级代码
    ,cotas_name -- 联系人名称
    ,tel_num -- 电话号码
    ,fax_num -- 传真号码
    ,issuer_flg -- 发行人标志
    ,issuer_id -- 发行人编号
    ,guartor_flg -- 担保人标志
    ,guartor_id -- 担保人编号
    ,fin_inst_flg -- 金融机构标志
    ,trust_org_flg -- 托管机构标志
    ,indus_type_cd -- 行业类型代码
    ,elec_ibank_no -- 电子联行号
    ,pay_bk_bank_no -- 支付行行号
    ,swift_id -- SWIFT编号
    ,cust_id -- 客户编号
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
    ,nvl(n.dept_id, o.dept_id) as dept_id -- 部门编号
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.cntpty_abbr, o.cntpty_abbr) as cntpty_abbr -- 交易对手简称
    ,nvl(n.cntpty_fname, o.cntpty_fname) as cntpty_fname -- 交易对手全称
    ,nvl(n.cntpty_en_abbr, o.cntpty_en_abbr) as cntpty_en_abbr -- 交易对手英文简称
    ,nvl(n.cntpty_en_name, o.cntpty_en_name) as cntpty_en_name -- 交易对手英文名称
    ,nvl(n.elec_cert_name, o.elec_cert_name) as elec_cert_name -- 电子证书名称
    ,nvl(n.elec_cert_id, o.elec_cert_id) as elec_cert_id -- 电子证书编号
    ,nvl(n.elec_cert_flg, o.elec_cert_flg) as elec_cert_flg -- 电子证书标志
    ,nvl(n.intnal_rating_level_cd, o.intnal_rating_level_cd) as intnal_rating_level_cd -- 内部评级等级代码
    ,nvl(n.cotas_name, o.cotas_name) as cotas_name -- 联系人名称
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.fax_num, o.fax_num) as fax_num -- 传真号码
    ,nvl(n.issuer_flg, o.issuer_flg) as issuer_flg -- 发行人标志
    ,nvl(n.issuer_id, o.issuer_id) as issuer_id -- 发行人编号
    ,nvl(n.guartor_flg, o.guartor_flg) as guartor_flg -- 担保人标志
    ,nvl(n.guartor_id, o.guartor_id) as guartor_id -- 担保人编号
    ,nvl(n.fin_inst_flg, o.fin_inst_flg) as fin_inst_flg -- 金融机构标志
    ,nvl(n.trust_org_flg, o.trust_org_flg) as trust_org_flg -- 托管机构标志
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
    ,nvl(n.elec_ibank_no, o.elec_ibank_no) as elec_ibank_no -- 电子联行号
    ,nvl(n.pay_bk_bank_no, o.pay_bk_bank_no) as pay_bk_bank_no -- 支付行行号
    ,nvl(n.swift_id, o.swift_id) as swift_id -- SWIFT编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.party_id is null
                and o.lp_id is null
            ) or (
                o.dept_id <> n.dept_id
                or o.cntpty_id <> n.cntpty_id
                or o.cntpty_abbr <> n.cntpty_abbr
                or o.cntpty_fname <> n.cntpty_fname
                or o.cntpty_en_abbr <> n.cntpty_en_abbr
                or o.cntpty_en_name <> n.cntpty_en_name
                or o.elec_cert_name <> n.elec_cert_name
                or o.elec_cert_id <> n.elec_cert_id
                or o.elec_cert_flg <> n.elec_cert_flg
                or o.intnal_rating_level_cd <> n.intnal_rating_level_cd
                or o.cotas_name <> n.cotas_name
                or o.tel_num <> n.tel_num
                or o.fax_num <> n.fax_num
                or o.issuer_flg <> n.issuer_flg
                or o.issuer_id <> n.issuer_id
                or o.guartor_flg <> n.guartor_flg
                or o.guartor_id <> n.guartor_id
                or o.fin_inst_flg <> n.fin_inst_flg
                or o.trust_org_flg <> n.trust_org_flg
                or o.indus_type_cd <> n.indus_type_cd
                or o.elec_ibank_no <> n.elec_ibank_no
                or o.pay_bk_bank_no <> n.pay_bk_bank_no
                or o.swift_id <> n.swift_id
                or o.cust_id <> n.cust_id
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
from ${iml_schema}.pty_cap_cntpty_info_ctmsf1_tm n
    full join ${iml_schema}.pty_cap_cntpty_info_ctmsf1_bk o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_cap_cntpty_info truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_cap_cntpty_info exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.pty_cap_cntpty_info_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_cap_cntpty_info drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_cap_cntpty_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_cap_cntpty_info_ctmsf1_tm purge;
drop table ${iml_schema}.pty_cap_cntpty_info_ctmsf1_ex purge;
drop table ${iml_schema}.pty_cap_cntpty_info_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_cap_cntpty_info', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);