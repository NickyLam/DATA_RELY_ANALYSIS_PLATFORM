/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_fcurr_bond_party_ctmsf2
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
drop table ${iml_schema}.pty_fcurr_bond_party_ctmsf2_tm purge;
drop table ${iml_schema}.pty_fcurr_bond_party_ctmsf2_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_fcurr_bond_party add partition p_ctmsf2 values ('ctmsf2')(
        subpartition p_ctmsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_fcurr_bond_party modify partition p_ctmsf2
    add subpartition p_ctmsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_fcurr_bond_party_ctmsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_fcurr_bond_party partition for ('ctmsf2')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_fcurr_bond_party_ctmsf2_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cntpty_id -- 交易对手编号
    ,super_party_id -- 上级当事人编号
    ,dc_elec_cert_id -- 本币电子证书编号
    ,status_cd -- 状态代码
    ,lp_name -- 法人名称
    ,tel_num -- 电话号码
    ,fax_num -- 传真号码
    ,cust_id -- 客户编号
    ,intnal_crdt_rating_id -- 内部信用评级编号
    ,intnal_crdt_rating_name -- 内部信用评级名称
    ,ibank_no -- 联行号
    ,lg_pay_sys_bank_no -- 大额支付系统行号
    ,issuer_id -- 发行人编号
    ,issuer_flg -- 发行人标志
    ,fin_inst_flg -- 金融机构标志
    ,guartor_flg -- 担保人标志
    ,trust_org_flg -- 托管机构标志
    ,dc_mem_cd -- 本币会员代码
    ,mem_src_cd -- 会员来源代码
    ,parent_corp_flg -- 母公司标志
    ,parent_corp_group_id -- 母公司群组编号
    ,org_id -- 机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_fcurr_bond_party
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_fcurr_bond_party_ctmsf2_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_fcurr_bond_party partition for ('ctmsf2') where 0=1;

-- 2.1 insert data to tm table
-- ctms_v_rms_cptys-1
insert into ${iml_schema}.pty_fcurr_bond_party_ctmsf2_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cntpty_id -- 交易对手编号
    ,super_party_id -- 上级当事人编号
    ,dc_elec_cert_id -- 本币电子证书编号
    ,status_cd -- 状态代码
    ,lp_name -- 法人名称
    ,tel_num -- 电话号码
    ,fax_num -- 传真号码
    ,cust_id -- 客户编号
    ,intnal_crdt_rating_id -- 内部信用评级编号
    ,intnal_crdt_rating_name -- 内部信用评级名称
    ,ibank_no -- 联行号
    ,lg_pay_sys_bank_no -- 大额支付系统行号
    ,issuer_id -- 发行人编号
    ,issuer_flg -- 发行人标志
    ,fin_inst_flg -- 金融机构标志
    ,guartor_flg -- 担保人标志
    ,trust_org_flg -- 托管机构标志
    ,dc_mem_cd -- 本币会员代码
    ,mem_src_cd -- 会员来源代码
    ,parent_corp_flg -- 母公司标志
    ,parent_corp_group_id -- 母公司群组编号
    ,org_id -- 机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101005'||P1.ENTYID -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.ENTYID -- 交易对手编号
    ,'101005'||P1.ENTYID -- 上级当事人编号
    ,P1.CMSCOUNTERPARTYID -- 本币电子证书编号
    ,P1.STATUS -- 状态代码
    ,P1.CONTACTNAME -- 法人名称
    ,P1.TELEPHONE -- 电话号码
    ,P1.FAX -- 传真号码
    ,P1.LABEL -- 客户编号
    ,TO_CHAR(P1.RATINGLEVEL) -- 内部信用评级编号
    ,P1.RATINGLEVELNAME -- 内部信用评级名称
    ,P1.EXCODE -- 联行号
    ,P1.EXACCOUNT -- 大额支付系统行号
    ,P1.REFISSUERID -- 发行人编号
    ,P1.ISISSUER -- 发行人标志
    ,P1.ISBANK -- 金融机构标志
    ,P1.ISGUARANTEE -- 担保人标志
    ,P1.ISCUSTODY -- 托管机构标志
    ,P1.CFETSMEMBERID -- 本币会员代码
    ,P1.CFETSMEMBERATTR -- 会员来源代码
    ,P1.ENTITYTYPE -- 母公司标志
    ,P1.GROUPID -- 母公司群组编号
    ,TO_CHAR(P1.BRANCHID) -- 机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_rms_cptys' -- 源表名称
    ,'ctmsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_rms_cptys p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_fcurr_bond_party_ctmsf2_tm 
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
insert /*+ append */ into ${iml_schema}.pty_fcurr_bond_party_ctmsf2_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cntpty_id -- 交易对手编号
    ,super_party_id -- 上级当事人编号
    ,dc_elec_cert_id -- 本币电子证书编号
    ,status_cd -- 状态代码
    ,lp_name -- 法人名称
    ,tel_num -- 电话号码
    ,fax_num -- 传真号码
    ,cust_id -- 客户编号
    ,intnal_crdt_rating_id -- 内部信用评级编号
    ,intnal_crdt_rating_name -- 内部信用评级名称
    ,ibank_no -- 联行号
    ,lg_pay_sys_bank_no -- 大额支付系统行号
    ,issuer_id -- 发行人编号
    ,issuer_flg -- 发行人标志
    ,fin_inst_flg -- 金融机构标志
    ,guartor_flg -- 担保人标志
    ,trust_org_flg -- 托管机构标志
    ,dc_mem_cd -- 本币会员代码
    ,mem_src_cd -- 会员来源代码
    ,parent_corp_flg -- 母公司标志
    ,parent_corp_group_id -- 母公司群组编号
    ,org_id -- 机构编号
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
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.super_party_id, o.super_party_id) as super_party_id -- 上级当事人编号
    ,nvl(n.dc_elec_cert_id, o.dc_elec_cert_id) as dc_elec_cert_id -- 本币电子证书编号
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.lp_name, o.lp_name) as lp_name -- 法人名称
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.fax_num, o.fax_num) as fax_num -- 传真号码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.intnal_crdt_rating_id, o.intnal_crdt_rating_id) as intnal_crdt_rating_id -- 内部信用评级编号
    ,nvl(n.intnal_crdt_rating_name, o.intnal_crdt_rating_name) as intnal_crdt_rating_name -- 内部信用评级名称
    ,nvl(n.ibank_no, o.ibank_no) as ibank_no -- 联行号
    ,nvl(n.lg_pay_sys_bank_no, o.lg_pay_sys_bank_no) as lg_pay_sys_bank_no -- 大额支付系统行号
    ,nvl(n.issuer_id, o.issuer_id) as issuer_id -- 发行人编号
    ,nvl(n.issuer_flg, o.issuer_flg) as issuer_flg -- 发行人标志
    ,nvl(n.fin_inst_flg, o.fin_inst_flg) as fin_inst_flg -- 金融机构标志
    ,nvl(n.guartor_flg, o.guartor_flg) as guartor_flg -- 担保人标志
    ,nvl(n.trust_org_flg, o.trust_org_flg) as trust_org_flg -- 托管机构标志
    ,nvl(n.dc_mem_cd, o.dc_mem_cd) as dc_mem_cd -- 本币会员代码
    ,nvl(n.mem_src_cd, o.mem_src_cd) as mem_src_cd -- 会员来源代码
    ,nvl(n.parent_corp_flg, o.parent_corp_flg) as parent_corp_flg -- 母公司标志
    ,nvl(n.parent_corp_group_id, o.parent_corp_group_id) as parent_corp_group_id -- 母公司群组编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.party_id is null
                and o.lp_id is null
            ) or (
                o.cntpty_id <> n.cntpty_id
                or o.super_party_id <> n.super_party_id
                or o.dc_elec_cert_id <> n.dc_elec_cert_id
                or o.status_cd <> n.status_cd
                or o.lp_name <> n.lp_name
                or o.tel_num <> n.tel_num
                or o.fax_num <> n.fax_num
                or o.cust_id <> n.cust_id
                or o.intnal_crdt_rating_id <> n.intnal_crdt_rating_id
                or o.intnal_crdt_rating_name <> n.intnal_crdt_rating_name
                or o.ibank_no <> n.ibank_no
                or o.lg_pay_sys_bank_no <> n.lg_pay_sys_bank_no
                or o.issuer_id <> n.issuer_id
                or o.issuer_flg <> n.issuer_flg
                or o.fin_inst_flg <> n.fin_inst_flg
                or o.guartor_flg <> n.guartor_flg
                or o.trust_org_flg <> n.trust_org_flg
                or o.dc_mem_cd <> n.dc_mem_cd
                or o.mem_src_cd <> n.mem_src_cd
                or o.parent_corp_flg <> n.parent_corp_flg
                or o.parent_corp_group_id <> n.parent_corp_group_id
                or o.org_id <> n.org_id
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
from ${iml_schema}.pty_fcurr_bond_party_ctmsf2_tm n
    full join ${iml_schema}.pty_fcurr_bond_party_ctmsf2_bk o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_fcurr_bond_party truncate partition for ('ctmsf2') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_fcurr_bond_party exchange subpartition p_ctmsf2_${batch_date} with table ${iml_schema}.pty_fcurr_bond_party_ctmsf2_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_fcurr_bond_party drop subpartition p_ctmsf2_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_fcurr_bond_party to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_fcurr_bond_party_ctmsf2_tm purge;
drop table ${iml_schema}.pty_fcurr_bond_party_ctmsf2_ex purge;
drop table ${iml_schema}.pty_fcurr_bond_party_ctmsf2_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_fcurr_bond_party', partname => 'p_ctmsf2_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);