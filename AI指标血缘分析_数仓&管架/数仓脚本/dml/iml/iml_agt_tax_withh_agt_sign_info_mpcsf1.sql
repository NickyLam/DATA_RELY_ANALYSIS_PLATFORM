/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_tax_withh_agt_sign_info_mpcsf1
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
drop table ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_tm purge;
drop table ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_tax_withh_agt_sign_info add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_tax_withh_agt_sign_info modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_tax_withh_agt_sign_info partition for ('mpcsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_dt -- 签约日期
    ,sign_flow_num -- 签约流水号
    ,sign_tm -- 签约时间
    ,sign_agt_id -- 签约协议编号
    ,taxpayer_id -- 纳税人编号
    ,org_cate_cd -- 机关类别代码
    ,impose_org_id -- 征收机关编号
    ,cust_type_cd -- 客户类型代码
    ,withh_acct_id -- 扣缴账户编号
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,sign_org_id -- 签约机构编号
    ,oper_teller_id -- 操作柜员编号
    ,check_teller_id -- 复核柜员编号
    ,matn_org_id -- 维护机构编号
    ,matn_teller_id -- 维护柜员编号
    ,matn_auth_teller_id -- 维护授权柜员编号
    ,matn_dt -- 维护日期
    ,matn_tm -- 维护时间
    ,sign_status_cd -- 签约状态代码
    ,remark -- 备注
    ,prov_city_ets_idf_cd -- 省市ETS标识代码
    ,impose_org_name -- 征收机关名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_tax_withh_agt_sign_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_tax_withh_agt_sign_info partition for ('mpcsf1') where 0=1;

-- 2.1 insert data to tm table
-- mpcs_a49tefetsreg-1
insert into ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_dt -- 签约日期
    ,sign_flow_num -- 签约流水号
    ,sign_tm -- 签约时间
    ,sign_agt_id -- 签约协议编号
    ,taxpayer_id -- 纳税人编号
    ,org_cate_cd -- 机关类别代码
    ,impose_org_id -- 征收机关编号
    ,cust_type_cd -- 客户类型代码
    ,withh_acct_id -- 扣缴账户编号
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,sign_org_id -- 签约机构编号
    ,oper_teller_id -- 操作柜员编号
    ,check_teller_id -- 复核柜员编号
    ,matn_org_id -- 维护机构编号
    ,matn_teller_id -- 维护柜员编号
    ,matn_auth_teller_id -- 维护授权柜员编号
    ,matn_dt -- 维护日期
    ,matn_tm -- 维护时间
    ,sign_status_cd -- 签约状态代码
    ,remark -- 备注
    ,prov_city_ets_idf_cd -- 省市ETS标识代码
    ,impose_org_name -- 征收机关名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '130027'||P1.SIGNDT||P1.SIGNSQ -- 协议编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.SIGNDT) -- 签约日期
    ,P1.SIGNSQ -- 签约流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.SIGNDT||replace(P1.SIGNTM,':','')) -- 签约时间
    ,P1.CNTRNO -- 签约协议编号
    ,P1.TXPYCD -- 纳税人编号
    ,P1.TXBRCH -- 机关类别代码
    ,P1.ORIGCD -- 征收机关编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CUSTTP END -- 客户类型代码
    ,P1.ACCTNO -- 扣缴账户编号
    ,P1.ACCTNA -- 账户名称
    ,P1.OPENBR -- 开户机构编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.IDTFTP END -- 证件类型代码
    ,P1.IDTFNO -- 证件号码
    ,P1.BRCHNO -- 签约机构编号
    ,P1.USERID -- 操作柜员编号
    ,P1.CKBKUS -- 复核柜员编号
    ,P1.MAINBR -- 维护机构编号
    ,P1.MAINUS -- 维护柜员编号
    ,P1.CLCKUS -- 维护授权柜员编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.MAINDT) -- 维护日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MAINDT||replace(P1.MAINTM,':','')) -- 维护时间
    ,nvl(trim(P1.SIGNST),'-') -- 签约状态代码
    ,P1.REMARK -- 备注
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ETSFLG END -- 省市ETS标识代码
    ,P1.ORIGNA -- 征收机关名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a49tefetsreg' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a49tefetsreg p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CUSTTP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A49TEFETSREG'
        AND R1.SRC_FIELD_EN_NAME= 'CUSTTP'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_TAX_WITHH_AGT_SIGN_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.IDTFTP = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A49TEFETSREG'
        AND R2.SRC_FIELD_EN_NAME= 'IDTFTP'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_TAX_WITHH_AGT_SIGN_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ETSFLG = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A49TEFETSREG'
        AND R3.SRC_FIELD_EN_NAME= 'ETSFLG'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_TAX_WITHH_AGT_SIGN_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'PROV_CITY_ETS_IDF_CD'
where  1 = 1 
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_tm 
  	                                group by 
  	                                        agt_id
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
insert /*+ append */ into ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_dt -- 签约日期
    ,sign_flow_num -- 签约流水号
    ,sign_tm -- 签约时间
    ,sign_agt_id -- 签约协议编号
    ,taxpayer_id -- 纳税人编号
    ,org_cate_cd -- 机关类别代码
    ,impose_org_id -- 征收机关编号
    ,cust_type_cd -- 客户类型代码
    ,withh_acct_id -- 扣缴账户编号
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,sign_org_id -- 签约机构编号
    ,oper_teller_id -- 操作柜员编号
    ,check_teller_id -- 复核柜员编号
    ,matn_org_id -- 维护机构编号
    ,matn_teller_id -- 维护柜员编号
    ,matn_auth_teller_id -- 维护授权柜员编号
    ,matn_dt -- 维护日期
    ,matn_tm -- 维护时间
    ,sign_status_cd -- 签约状态代码
    ,remark -- 备注
    ,prov_city_ets_idf_cd -- 省市ETS标识代码
    ,impose_org_name -- 征收机关名称
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(n.sign_flow_num, o.sign_flow_num) as sign_flow_num -- 签约流水号
    ,nvl(n.sign_tm, o.sign_tm) as sign_tm -- 签约时间
    ,nvl(n.sign_agt_id, o.sign_agt_id) as sign_agt_id -- 签约协议编号
    ,nvl(n.taxpayer_id, o.taxpayer_id) as taxpayer_id -- 纳税人编号
    ,nvl(n.org_cate_cd, o.org_cate_cd) as org_cate_cd -- 机关类别代码
    ,nvl(n.impose_org_id, o.impose_org_id) as impose_org_id -- 征收机关编号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.withh_acct_id, o.withh_acct_id) as withh_acct_id -- 扣缴账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.sign_org_id, o.sign_org_id) as sign_org_id -- 签约机构编号
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 操作柜员编号
    ,nvl(n.check_teller_id, o.check_teller_id) as check_teller_id -- 复核柜员编号
    ,nvl(n.matn_org_id, o.matn_org_id) as matn_org_id -- 维护机构编号
    ,nvl(n.matn_teller_id, o.matn_teller_id) as matn_teller_id -- 维护柜员编号
    ,nvl(n.matn_auth_teller_id, o.matn_auth_teller_id) as matn_auth_teller_id -- 维护授权柜员编号
    ,nvl(n.matn_dt, o.matn_dt) as matn_dt -- 维护日期
    ,nvl(n.matn_tm, o.matn_tm) as matn_tm -- 维护时间
    ,nvl(n.sign_status_cd, o.sign_status_cd) as sign_status_cd -- 签约状态代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.prov_city_ets_idf_cd, o.prov_city_ets_idf_cd) as prov_city_ets_idf_cd -- 省市ETS标识代码
    ,nvl(n.impose_org_name, o.impose_org_name) as impose_org_name -- 征收机关名称
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.sign_dt <> n.sign_dt
                or o.sign_flow_num <> n.sign_flow_num
                or o.sign_tm <> n.sign_tm
                or o.sign_agt_id <> n.sign_agt_id
                or o.taxpayer_id <> n.taxpayer_id
                or o.org_cate_cd <> n.org_cate_cd
                or o.impose_org_id <> n.impose_org_id
                or o.cust_type_cd <> n.cust_type_cd
                or o.withh_acct_id <> n.withh_acct_id
                or o.acct_name <> n.acct_name
                or o.open_acct_org_id <> n.open_acct_org_id
                or o.cert_type_cd <> n.cert_type_cd
                or o.cert_no <> n.cert_no
                or o.sign_org_id <> n.sign_org_id
                or o.oper_teller_id <> n.oper_teller_id
                or o.check_teller_id <> n.check_teller_id
                or o.matn_org_id <> n.matn_org_id
                or o.matn_teller_id <> n.matn_teller_id
                or o.matn_auth_teller_id <> n.matn_auth_teller_id
                or o.matn_dt <> n.matn_dt
                or o.matn_tm <> n.matn_tm
                or o.sign_status_cd <> n.sign_status_cd
                or o.remark <> n.remark
                or o.prov_city_ets_idf_cd <> n.prov_city_ets_idf_cd
                or o.impose_org_name <> n.impose_org_name
            ) or (
                 case when (
                           n.agt_id is null
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
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_tm n
    full join ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_tax_withh_agt_sign_info truncate partition for ('mpcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_tax_withh_agt_sign_info exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_tax_withh_agt_sign_info drop subpartition p_mpcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_tax_withh_agt_sign_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_tm purge;
drop table ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_ex purge;
drop table ${iml_schema}.agt_tax_withh_agt_sign_info_mpcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_tax_withh_agt_sign_info', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);