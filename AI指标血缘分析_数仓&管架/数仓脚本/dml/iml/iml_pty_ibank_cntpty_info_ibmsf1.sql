/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_ibank_cntpty_info_ibmsf1
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
drop table ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_tm purge;
drop table ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_ibank_cntpty_info add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_ibank_cntpty_info modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_ibank_cntpty_info partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_party_id -- 源当事人编号
    ,org_id -- 机构编号
    ,super_org_id -- 上级机构编号
    ,party_name -- 当事人名称
    ,party_fname -- 当事人全称
    ,party_alias -- 当事人别名
    ,party_pinyin -- 当事人拼音
    ,en_name -- 英文名称
    ,en_fname -- 英文全称
    ,status_cd -- 状态代码
    ,found_dt -- 成立日期
    ,bus_lics_num -- 营业执照号码
    ,party_cd_cert_id -- 当事人代码证编号
    ,fin_lics_id -- 金融许可证编号
    ,dc_pay_sys_bank_no -- 本币支付系统行号
    ,fcurr_pay_sys_bank_no -- 外币支付系统行号
    ,rgst -- 注册地
    ,party_cls_descb -- 当事人分类描述
    ,party_type_cd -- 当事人类型代码
    ,cust_id -- 客户编号
    ,mar_maker_flg -- 做市商标志
    ,spv_flg -- SPV标志
    ,matn_org_id -- 维护机构编号
    ,matn_org_name -- 维护机构名称
    ,rwa_cust_cls_name -- RWA客户分类名称
    ,org_cls_cd -- 机构分类代码
    ,org_lev_cd -- 机构级别代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_ibank_cntpty_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_ibank_cntpty_info partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_institution-1
insert into ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_party_id -- 源当事人编号
    ,org_id -- 机构编号
    ,super_org_id -- 上级机构编号
    ,party_name -- 当事人名称
    ,party_fname -- 当事人全称
    ,party_alias -- 当事人别名
    ,party_pinyin -- 当事人拼音
    ,en_name -- 英文名称
    ,en_fname -- 英文全称
    ,status_cd -- 状态代码
    ,found_dt -- 成立日期
    ,bus_lics_num -- 营业执照号码
    ,party_cd_cert_id -- 当事人代码证编号
    ,fin_lics_id -- 金融许可证编号
    ,dc_pay_sys_bank_no -- 本币支付系统行号
    ,fcurr_pay_sys_bank_no -- 外币支付系统行号
    ,rgst -- 注册地
    ,party_cls_descb -- 当事人分类描述
    ,party_type_cd -- 当事人类型代码
    ,cust_id -- 客户编号
    ,mar_maker_flg -- 做市商标志
    ,spv_flg -- SPV标志
    ,matn_org_id -- 维护机构编号
    ,matn_org_name -- 维护机构名称
    ,rwa_cust_cls_name -- RWA客户分类名称
    ,org_cls_cd -- 机构分类代码
    ,org_lev_cd -- 机构级别代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '301006'||to_char(P1.I_ID) -- 当事人编号
    ,'9999' -- 法人编号
    ,to_char(P1.I_ID) -- 源当事人编号
    ,P1.ORG_ID -- 机构编号
    ,case when TRIM(p3.org_id) is not null then TRIM(p3.org_id)
     when to_char(p2.parent_id) is not null then to_char(p2.parent_id)
     else ' ' 
end -- 上级机构编号
    ,P1.I_NAME -- 当事人名称
    ,P1.I_FULLNAME -- 当事人全称
    ,P1.I_ALIAS -- 当事人别名
    ,P1.PY_CODE -- 当事人拼音
    ,P1.EN_NAME -- 英文名称
    ,P1.EN_FULLNAME -- 英文全称
    ,P1.STATUS  -- 状态代码
    ,${iml_schema}.dateformat_min(P1.ONLINE_DATE) -- 成立日期
    ,P1.I_BUSINESS_LICENSE -- 营业执照号码
    ,P1.I_LR_INST_CODE -- 当事人代码证编号
    ,P1.I_FINANCIAL_LICENSE -- 金融许可证编号
    ,P1.CNAPS_CODE -- 本币支付系统行号
    ,P1.SWIFT_CODE -- 外币支付系统行号
    ,P1.BELONG_TO_AREA -- 注册地
    ,P1.T_PATH -- 当事人分类描述
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.INST_CLASS END -- 当事人类型代码
    ,P1.CORE_SYS_CUSTOMER_CODE -- 客户编号
    ,P1.IS_MARKET_MAKER -- 做市商标志
    ,P1.IS_SPV -- SPV标志
    ,NVL(TRIM(p4.org_id),to_char(P1.EDIT_IID)） -- 维护机构编号
    ,P1.EDIT_INAME -- 维护机构名称
    ,P1.RWA_NAME -- RWA客户分类名称
    ,p1.T_CODE -- 机构分类代码
    ,nvl(trim(P1.I_LEVEL_M),'-') -- 机构级别代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_institution' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_institution p1
    left join (select a.*, row_number() over(partition by i_id order by parent_id desc) as rn
     from iol.ibms_ttrd_institution_map a
     where a.start_dt <= to_date('${batch_date}','yyyymmdd') and a.end_dt > to_date('${batch_date}','yyyymmdd')) p2 on  p1.i_id = p2.i_id 
  and p2.rn = 1
    left join iol.ibms_ttrd_institution  p3 on p2.parent_id=p3.i_id
 and p2.rn=1
 and p3.start_dt <= to_date('${batch_date}','yyyymmdd') and p3.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.INST_CLASS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_INSTITUTION'
        AND R2.SRC_FIELD_EN_NAME= 'INST_CLASS'
        AND R2.TARGET_TAB_EN_NAME= 'PTY_IBANK_CNTPTY_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PARTY_TYPE_CD'
    left join iol.ibms_ttrd_institution  p4 on  P1.EDIT_IID=p4.i_id
 and p4.start_dt <= to_date('${batch_date}','yyyymmdd') and p4.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_party_id -- 源当事人编号
    ,org_id -- 机构编号
    ,super_org_id -- 上级机构编号
    ,party_name -- 当事人名称
    ,party_fname -- 当事人全称
    ,party_alias -- 当事人别名
    ,party_pinyin -- 当事人拼音
    ,en_name -- 英文名称
    ,en_fname -- 英文全称
    ,status_cd -- 状态代码
    ,found_dt -- 成立日期
    ,bus_lics_num -- 营业执照号码
    ,party_cd_cert_id -- 当事人代码证编号
    ,fin_lics_id -- 金融许可证编号
    ,dc_pay_sys_bank_no -- 本币支付系统行号
    ,fcurr_pay_sys_bank_no -- 外币支付系统行号
    ,rgst -- 注册地
    ,party_cls_descb -- 当事人分类描述
    ,party_type_cd -- 当事人类型代码
    ,cust_id -- 客户编号
    ,mar_maker_flg -- 做市商标志
    ,spv_flg -- SPV标志
    ,matn_org_id -- 维护机构编号
    ,matn_org_name -- 维护机构名称
    ,rwa_cust_cls_name -- RWA客户分类名称
    ,org_cls_cd -- 机构分类代码
    ,org_lev_cd -- 机构级别代码
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
    ,nvl(n.src_party_id, o.src_party_id) as src_party_id -- 源当事人编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.super_org_id, o.super_org_id) as super_org_id -- 上级机构编号
    ,nvl(n.party_name, o.party_name) as party_name -- 当事人名称
    ,nvl(n.party_fname, o.party_fname) as party_fname -- 当事人全称
    ,nvl(n.party_alias, o.party_alias) as party_alias -- 当事人别名
    ,nvl(n.party_pinyin, o.party_pinyin) as party_pinyin -- 当事人拼音
    ,nvl(n.en_name, o.en_name) as en_name -- 英文名称
    ,nvl(n.en_fname, o.en_fname) as en_fname -- 英文全称
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.found_dt, o.found_dt) as found_dt -- 成立日期
    ,nvl(n.bus_lics_num, o.bus_lics_num) as bus_lics_num -- 营业执照号码
    ,nvl(n.party_cd_cert_id, o.party_cd_cert_id) as party_cd_cert_id -- 当事人代码证编号
    ,nvl(n.fin_lics_id, o.fin_lics_id) as fin_lics_id -- 金融许可证编号
    ,nvl(n.dc_pay_sys_bank_no, o.dc_pay_sys_bank_no) as dc_pay_sys_bank_no -- 本币支付系统行号
    ,nvl(n.fcurr_pay_sys_bank_no, o.fcurr_pay_sys_bank_no) as fcurr_pay_sys_bank_no -- 外币支付系统行号
    ,nvl(n.rgst, o.rgst) as rgst -- 注册地
    ,nvl(n.party_cls_descb, o.party_cls_descb) as party_cls_descb -- 当事人分类描述
    ,nvl(n.party_type_cd, o.party_type_cd) as party_type_cd -- 当事人类型代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.mar_maker_flg, o.mar_maker_flg) as mar_maker_flg -- 做市商标志
    ,nvl(n.spv_flg, o.spv_flg) as spv_flg -- SPV标志
    ,nvl(n.matn_org_id, o.matn_org_id) as matn_org_id -- 维护机构编号
    ,nvl(n.matn_org_name, o.matn_org_name) as matn_org_name -- 维护机构名称
    ,nvl(n.rwa_cust_cls_name, o.rwa_cust_cls_name) as rwa_cust_cls_name -- RWA客户分类名称
    ,nvl(n.org_cls_cd, o.org_cls_cd) as org_cls_cd -- 机构分类代码
    ,nvl(n.org_lev_cd, o.org_lev_cd) as org_lev_cd -- 机构级别代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.party_id is null
                and o.lp_id is null
            ) or (
                o.src_party_id <> n.src_party_id
                or o.org_id <> n.org_id
                or o.super_org_id <> n.super_org_id
                or o.party_name <> n.party_name
                or o.party_fname <> n.party_fname
                or o.party_alias <> n.party_alias
                or o.party_pinyin <> n.party_pinyin
                or o.en_name <> n.en_name
                or o.en_fname <> n.en_fname
                or o.status_cd <> n.status_cd
                or o.found_dt <> n.found_dt
                or o.bus_lics_num <> n.bus_lics_num
                or o.party_cd_cert_id <> n.party_cd_cert_id
                or o.fin_lics_id <> n.fin_lics_id
                or o.dc_pay_sys_bank_no <> n.dc_pay_sys_bank_no
                or o.fcurr_pay_sys_bank_no <> n.fcurr_pay_sys_bank_no
                or o.rgst <> n.rgst
                or o.party_cls_descb <> n.party_cls_descb
                or o.party_type_cd <> n.party_type_cd
                or o.cust_id <> n.cust_id
                or o.mar_maker_flg <> n.mar_maker_flg
                or o.spv_flg <> n.spv_flg
                or o.matn_org_id <> n.matn_org_id
                or o.matn_org_name <> n.matn_org_name
                or o.rwa_cust_cls_name <> n.rwa_cust_cls_name
                or o.org_cls_cd <> n.org_cls_cd
                or o.org_lev_cd <> n.org_lev_cd
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
from ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_tm n
    full join ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_bk o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_ibank_cntpty_info truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_ibank_cntpty_info exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_ibank_cntpty_info drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_ibank_cntpty_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_tm purge;
drop table ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_ex purge;
drop table ${iml_schema}.pty_ibank_cntpty_info_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_ibank_cntpty_info', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);