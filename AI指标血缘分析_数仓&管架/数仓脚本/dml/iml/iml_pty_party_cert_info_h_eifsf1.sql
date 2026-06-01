/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_party_cert_info_h_eifsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_party_cert_info_h add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_party_cert_info_h_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_cert_info_h partition for ('eifsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_party_cert_info_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_cert_info_h_eifsf1_op purge;
drop table ${iml_schema}.pty_party_cert_info_h_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_cert_info_h_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_cert_info_h partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_party_cert_info_h_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_cert_info_h partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_party_cert_info_h_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_cert_info_h partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_t01_corp_cust_info-
insert into ${iml_schema}.pty_party_cert_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.Cust_Num -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,'2071' -- 证件类型代码
    ,P1.NATIONAL_TAX_NO -- 证件号码
    ,' ' -- 证件地址
    ,' ' -- 发证机关
    ,'CHN' -- 发证机关国家代码
    ,to_date('00010101','yyyymmdd') -- 证件生效日期
    ,to_date('29991231','yyyymmdd') -- 证件失效日期
    ,'9999' -- 发证机关行政区划代码
    ,' ' -- 信用代码证编号
    ,case when p1.updated_ts = to_date('99991231','yyyymmdd') then '1' else '0' end -- 证件有效标志
    ,' ' -- 证件状态代码
    ,'-' -- 主证件号标志
    ,'-' -- 联网核查标志
    ,'-' -- 联网核查结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_cust_info p1
 left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2 
   on p1.party_id = p2.party_id
  and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt>to_date('${batch_date}','yyyymmdd') 
 where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
  and trim(p2.party_id) is not null
  and trim(p1.national_tax_no) is not null
;
commit;

-- eifs_t01_corp_cust_info-2
insert into ${iml_schema}.pty_party_cert_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.Cust_Num -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,'2072' -- 证件类型代码
    ,P1.LAND_TAX_NO -- 证件号码
    ,' ' -- 证件地址
    ,' ' -- 发证机关
    ,'CHN' -- 发证机关国家代码
    ,to_date('00010101','yyyymmdd') -- 证件生效日期
    ,to_date('29991231','yyyymmdd') -- 证件失效日期
    ,'9999' -- 发证机关行政区划代码
    ,' ' -- 信用代码证编号
    ,case when p1.updated_ts = to_date('99991231','yyyymmdd') then '1' else '0' end -- 证件有效标志
    ,' ' -- 证件状态代码
    ,'-' -- 主证件号标志
    ,'-' -- 联网核查标志
    ,'-' -- 联网核查结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_cust_info p1
  left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2
    on p1.party_id = p2.party_id
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and trim(p2.party_id) is not null
   and trim(p1.land_tax_no) is not null
;
commit;

-- eifs_t01_corp_cust_info-3
insert into ${iml_schema}.pty_party_cert_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.Cust_Num -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,'2080' -- 证件类型代码
    ,P1.LICENCE_FOR_OPEN_ACCT -- 证件号码
    ,' ' -- 证件地址
    ,' ' -- 发证机关
    ,'CHN' -- 发证机关国家代码
    ,${iml_schema}.dateformat_min(p1.DATE_OF_APPROVAL) -- 证件生效日期
    ,to_date('29991231','yyyymmdd') -- 证件失效日期
    ,'9999' -- 发证机关行政区划代码
    ,' ' -- 信用代码证编号
    ,case when p1.updated_ts = to_date('99991231','yyyymmdd') then '1' else '0' end -- 证件有效标志
    ,' ' -- 证件状态代码
    ,'-' -- 主证件号标志
    ,'-' -- 联网核查标志
    ,'-' -- 联网核查结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_cust_info p1
    left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2 
      on p1.party_id=p2.party_id
     and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
    left join ${iol_schema}.eifs_t00_corp_cust_cert_ref p3 
      on p1.party_id = p3.party_id 
      and p3.cert_type_cd='2080'
     and p3.start_dt <= to_date('${batch_date}','yyyymmdd') and p3.end_dt > to_date('${batch_date}','yyyymmdd') 
 where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and trim(p2.party_id) is not null 
    and trim(p3.party_id) is null 
    and trim(p1.licence_for_open_acct) is not null
;
commit;

-- eifs_t01_corp_cust_info-4
insert into ${iml_schema}.pty_party_cert_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.Cust_Num -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,'2318' -- 证件类型代码
    ,P1.BUSI_OR_NOT_REG_CER -- 证件号码
    ,' ' -- 证件地址
    ,' ' -- 发证机关
    ,'CHN' -- 发证机关国家代码
    ,to_date('00010101','yyyymmdd') -- 证件生效日期
    ,to_date('29991231','yyyymmdd') -- 证件失效日期
    ,'9999' -- 发证机关行政区划代码
    ,' ' -- 信用代码证编号
    ,case when p1.updated_ts = to_date('99991231','yyyymmdd') then '1' else '0' end -- 证件有效标志
    ,' ' -- 证件状态代码
    ,'-' -- 主证件号标志
    ,'-' -- 联网核查标志
    ,'-' -- 联网核查结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.eifs_t01_corp_cust_info p1
  left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2
    on p1.party_id = p2.party_id
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.eifs_t00_corp_cust_cert_ref p3 
    on p1.party_id = p3.party_id 
   and p3.cert_type_cd = '2318'
   and p3.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and p3.end_dt > to_date('${batch_date}','yyyymmdd') 
 where p1.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and p1.end_dt > to_date('${batch_date}','yyyymmdd')
   and trim(p2.party_id) is not null 
   and trim(p3.party_id) is null 
   and trim(p1.busi_or_not_reg_cer) is not null;
commit;

-- eifs_t01_corp_cust_info-5
insert into ${iml_schema}.pty_party_cert_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.Cust_Num -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,'2100' -- 证件类型代码
    ,P1.ORG_CREDIT_CODE_CERT_NUM -- 证件号码
    ,' ' -- 证件地址
    ,' ' -- 发证机关
    ,'CHN' -- 发证机关国家代码
    ,to_date('00010101','yyyymmdd') -- 证件生效日期
    ,to_date('29991231','yyyymmdd') -- 证件失效日期
    ,'9999' -- 发证机关行政区划代码
    ,' ' -- 信用代码证编号
    ,case when p1.updated_ts = to_date('99991231','yyyymmdd') then '1' else '0' end -- 证件有效标志
    ,' ' -- 证件状态代码
    ,'-' -- 主证件号标志
    ,'-' -- 联网核查标志
    ,'-' -- 联网核查结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.eifs_t01_corp_cust_info p1
  left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2
    on p1.party_id = p2.party_id
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.eifs_t00_corp_cust_cert_ref p3 
    on p1.party_id = p3.party_id
   and p3.cert_type_cd = '2100' 
   and p3.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and p3.end_dt > to_date('${batch_date}','yyyymmdd') 
 where p1.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and p1.end_dt > to_date('${batch_date}','yyyymmdd')
   and trim(p2.party_id) is not null 
   and trim(p3.party_id) is null 
   and trim(p1.org_credit_code_cert_num) is not null;
commit;

-- eifs_t00_corp_cust_cert_ref-1
insert into ${iml_schema}.pty_party_cert_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.Cust_Num -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,nvl(trim(P1.CERT_TYPE_CD),'0000')-- 证件类型代码
    ,p1.Cert_Num -- 证件号码
    ,p1.Cert_Rgst_Addr -- 证件地址
    ,p1.Cert_Issue_Org_Name -- 发证机关
    ,'XXX' -- 发证机关国家代码
    ,${iml_schema}.dateformat_min(p1.Cert_Effect_Dt) -- 证件生效日期
    ,${iml_schema}.dateformat_max2(p1.Cert_Invalid_Dt) -- 证件失效日期
    ,nvl(trim(p1.Cert_Issue_Zone_Cd),'000000') -- 发证机关行政区划代码
    ,' ' -- 信用代码证编号
    ,case when p1.updated_ts = to_date('99991231','yyyymmdd') then '1' else '0' end -- 证件有效标志
    ,' ' -- 证件状态代码
    ,nvl(trim(p1.IS_MAIN_CERT),'-') -- 主证件号标志
    ,nvl(trim(p1.IS_NET_CHECK),'-') -- 联网核查标志
    ,nvl(trim(p1.NETWORK_VERIF),'-') -- 联网核查结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t00_corp_cust_cert_ref' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.eifs_t00_corp_cust_cert_ref p1
  left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2
    on p1.party_id = p2.party_id
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 inner join (select t2.*,
                    row_number() over(partition by party_id, is_main_cert order by t2.updated_ts desc) rn2
               from (select t1.*,
                            row_number() over(partition by party_id, cert_type_cd order by t1.is_main_cert desc, t1.updated_ts desc) rn1
                       from ${iol_schema}.eifs_t00_corp_cust_cert_ref t1
                      where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd') and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                        and trim(t1.cert_num) is not null
                        and trim(t1.cert_type_cd) is not null) t2
              where t2.rn1 = 1) p3 -- 过滤掉业务主键重复数据
    on p1.party_id = p3.party_id
   and p1.cert_index_seq = p3.cert_index_seq
   and (p3.is_main_cert <> '1' or p3.rn2 = 1) -- 当同一客户有两个主证件，且证件类型不同时，取最新一条
   left join ${iol_schema}.eifs_t01_corp_cust_info p4
    on p1.party_id = p4.party_id
   and p4.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p4.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and trim(p2.party_id) is not null
   and p1.cert_type_cd ='2071'
   and trim(p4.national_tax_no) is null 
;
commit;

-- eifs_t00_corp_cust_cert_ref-2
insert into ${iml_schema}.pty_party_cert_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.Cust_Num -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,nvl(trim(P1.CERT_TYPE_CD),'0000')-- 证件类型代码
    ,p1.Cert_Num -- 证件号码
    ,p1.Cert_Rgst_Addr -- 证件地址
    ,p1.Cert_Issue_Org_Name -- 发证机关
    ,'XXX' -- 发证机关国家代码
    ,${iml_schema}.dateformat_min(p1.Cert_Effect_Dt) -- 证件生效日期
    ,${iml_schema}.dateformat_max2(p1.Cert_Invalid_Dt) -- 证件失效日期
    ,nvl(trim(p1.Cert_Issue_Zone_Cd),'000000') -- 发证机关行政区划代码
    ,' ' -- 信用代码证编号
    ,case when p1.updated_ts = to_date('99991231','yyyymmdd') then '1' else '0' end -- 证件有效标志
    ,' ' -- 证件状态代码
    ,nvl(trim(p1.IS_MAIN_CERT),'-') -- 主证件号标志
    ,nvl(trim(p1.IS_NET_CHECK),'-') -- 联网核查标志
    ,nvl(trim(p1.NETWORK_VERIF),'-') -- 联网核查结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t00_corp_cust_cert_ref' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.eifs_t00_corp_cust_cert_ref p1
  left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2
    on p1.party_id = p2.party_id
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 inner join (select t2.*,
                    row_number() over(partition by party_id, is_main_cert order by t2.updated_ts desc) rn2
               from (select t1.*,
                            row_number() over(partition by party_id, cert_type_cd order by t1.is_main_cert desc, t1.updated_ts desc) rn1
                       from ${iol_schema}.eifs_t00_corp_cust_cert_ref t1
                      where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd') and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                        and trim(t1.cert_num) is not null
                        and trim(t1.cert_type_cd) is not null) t2
              where t2.rn1 = 1) p3 -- 过滤掉业务主键重复数据
    on p1.party_id = p3.party_id
   and p1.cert_index_seq = p3.cert_index_seq
   and (p3.is_main_cert <> '1' or p3.rn2 = 1) -- 当同一客户有两个主证件，且证件类型不同时，取最新一条
   left join ${iol_schema}.eifs_t01_corp_cust_info p4
    on p1.party_id = p4.party_id
   and p4.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p4.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and trim(p2.party_id) is not null
   and p1.cert_type_cd ='2072'
   and trim(p4.land_tax_no) is  null
;
commit;

-- eifs_t00_corp_cust_cert_ref-3
insert into ${iml_schema}.pty_party_cert_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.Cust_Num -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,nvl(trim(P1.CERT_TYPE_CD),'0000')-- 证件类型代码
    ,p1.Cert_Num -- 证件号码
    ,p1.Cert_Rgst_Addr -- 证件地址
    ,p1.Cert_Issue_Org_Name -- 发证机关
    ,'XXX' -- 发证机关国家代码
    ,${iml_schema}.dateformat_min(p1.Cert_Effect_Dt) -- 证件生效日期
    ,${iml_schema}.dateformat_max2(p1.Cert_Invalid_Dt) -- 证件失效日期
    ,nvl(trim(p1.Cert_Issue_Zone_Cd),'000000') -- 发证机关行政区划代码
    ,' ' -- 信用代码证编号
    ,case when p1.updated_ts = to_date('99991231','yyyymmdd') then '1' else '0' end -- 证件有效标志
    ,' ' -- 证件状态代码
    ,nvl(trim(p1.IS_MAIN_CERT),'-') -- 主证件号标志
    ,nvl(trim(p1.IS_NET_CHECK),'-') -- 联网核查标志
    ,nvl(trim(p1.NETWORK_VERIF),'-') -- 联网核查结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t00_corp_cust_cert_ref' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.eifs_t00_corp_cust_cert_ref p1
  left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2
    on p1.party_id = p2.party_id
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 inner join (select t2.*,
                    row_number() over(partition by party_id, is_main_cert order by t2.updated_ts desc) rn2
               from (select t1.*,
                            row_number() over(partition by party_id, cert_type_cd order by t1.is_main_cert desc, t1.updated_ts desc) rn1
                       from ${iol_schema}.eifs_t00_corp_cust_cert_ref t1
                      where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd') and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                        and trim(t1.cert_num) is not null
                        and trim(t1.cert_type_cd) is not null) t2
              where t2.rn1 = 1) p3 -- 过滤掉业务主键重复数据
    on p1.party_id = p3.party_id
   and p1.cert_index_seq = p3.cert_index_seq
   and (p3.is_main_cert <> '1' or p3.rn2 = 1) -- 当同一客户有两个主证件，且证件类型不同时，取最新一条
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and trim(p2.party_id) is not null
   and p1.cert_type_cd not in ('2071','2072')
;
commit;

-- eifs_t00_per_cust_cert_ref-
insert into ${iml_schema}.pty_party_cert_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.Cust_Num -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,nvl(trim(P1.CERT_TYPE_CD),'0000') -- 证件类型代码
    ,p1.Cert_Num -- 证件号码
    ,p1.Cert_Rgst_Addr -- 证件地址
    ,p1.Cert_Issue_Org_Name -- 发证机关
    ,nvl(trim(p1.Cert_Issue_Cty_Cd),'XXX') -- 发证机关国家代码
    ,${iml_schema}.dateformat_min(p1.Cert_Effect_Dt) -- 证件生效日期
    ,${iml_schema}.dateformat_max2(p1.Cert_Invalid_Dt) -- 证件失效日期
    ,nvl(trim(p1.Cert_Issue_Zone_Cd),'9999') -- 发证机关行政区划代码
    ,' ' -- 信用代码证编号
    ,case when p1.updated_ts = to_date('99991231','yyyymmdd') then '1' else '0' end -- 证件有效标志
    ,' ' -- 证件状态代码
    ,nvl(trim(p1.IS_MAIN_CERT),'-') -- 主证件号标志
    ,nvl(trim(p1.IS_NET_CHECK),'-') -- 联网核查标志
    ,nvl(trim(p1.NETWORK_VERIF),'-') -- 联网核查结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t00_per_cust_cert_ref' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.eifs_t00_per_cust_cert_ref p1
  left join ${iol_schema}.eifs_t00_per_cust_no_ref p2
    on p1.party_id = p2.party_id
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 inner join (select t2.*,
                    row_number() over(partition by party_id, is_main_cert order by t2.updated_ts desc) rn2
               from (select t1.*,
                            row_number() over(partition by party_id, cert_type_cd order by t1.updated_ts desc, t1.is_main_cert desc ) rn1
                       from ${iol_schema}.eifs_t00_per_cust_cert_ref t1
                      where t1.start_dt <=
                            to_date('${batch_date}', 'yyyymmdd')
                        and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                        and trim(t1.cert_num) is not null
                        and trim(t1.cert_type_cd) is not null) t2
              where t2.rn1 = 1) p3 -- 过滤掉业务主键重复数据
    on p1.party_id = p3.party_id
   and p1.cert_index_seq = p3.cert_index_seq
   and (p3.is_main_cert <> '1' or p3.rn2 = 1) -- 当同一客户有两个主证件，且证件类型不同时，取最新一条
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and trim(p2.party_id) is not null
   and (trim(p1.cert_type_cd) is not null and trim(p1.cert_num) is not null)
  ;
commit;



-- eifs_t01_corp_rel_corp_info-1
insert into ${iml_schema}.pty_party_cert_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.REL_ENTERP_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,nvl(trim(P1.RELA_CERT_TYPE_CD),'0000') -- 证件类型代码
    ,P1.RELA_CERT_NUM -- 证件号码
    ,' ' -- 证件地址
    ,' ' -- 发证机关
    ,'XXX' -- 发证机关国家代码
    ,${iml_schema}.dateformat_min(P1.RELA_CERT_EFFECT_DT) -- 证件生效日期
    , ${iml_schema}.dateformat_max2(P1.EXP_DATE_OF_RELA_CERT) -- 证件失效日期
    ,'9999' -- 发证机关行政区划代码
    ,' ' -- 信用代码证编号
    ,case when p1.updated_ts = to_date('99991231','yyyymmdd') then '1' else '0' end -- 证件有效标志
    ,' ' -- 证件状态代码
    ,'1' -- 主证件号标志
    ,'-' -- 联网核查标志
    ,'-' -- 联网核查结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_rel_corp_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.eifs_t01_corp_rel_corp_info p1
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and (trim(p1.rela_cert_type_cd) is not null 
         and trim(p1.rela_cert_num) is not null)
  ;
commit;

-- eifs_t01_corp_rel_per_info-1
insert into ${iml_schema}.pty_party_cert_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.REL_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,nvl(trim(P1.RELA_CERT_TYPE_CD),'0000') -- 证件类型代码
    ,P1.RELA_CERT_NUM -- 证件号码
    ,' ' -- 证件地址
    ,' ' -- 发证机关
    ,'XXX' -- 发证机关国家代码
    ,${iml_schema}.dateformat_min(P1.RELA_CERT_EFFECT_DT) -- 证件生效日期
    , ${iml_schema}.dateformat_max2(P1.EXP_DATE_OF_RELA_CERT) -- 证件失效日期
    ,'9999' -- 发证机关行政区划代码
    ,' ' -- 信用代码证编号
    ,case when p1.updated_ts = to_date('99991231','yyyymmdd') then '1' else '0' end -- 证件有效标志
    ,' ' -- 证件状态代码
    ,'1' -- 主证件号标志
    ,'-' -- 联网核查标志
    ,'-' -- 联网核查结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_rel_per_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_rel_per_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and (trim(p1.rela_cert_type_cd) is not null  
     and  trim(p1.rela_cert_num) is not null)
;
commit;

-- eifs_t01_per_rel_per_info-1
insert into ${iml_schema}.pty_party_cert_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.REL_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,nvl(trim(P1.RELA_CERT_TYPE_CD),'0000') -- 证件类型代码
    ,P1.RELA_CERT_NUM -- 证件号码
    ,' ' -- 证件地址
    ,' ' -- 发证机关
    ,'XXX' -- 发证机关国家代码
    ,${iml_schema}.dateformat_min(P1.RELA_CERT_EFFECT_DT) -- 证件生效日期
    , ${iml_schema}.dateformat_max2(P1.EXP_DATE_OF_RELA_CERT) -- 证件失效日期
    ,'9999' -- 发证机关行政区划代码
    ,' ' -- 信用代码证编号
    ,case when p1.updated_ts = to_date('99991231','yyyymmdd') then '1' else '0' end -- 证件有效标志
    ,' ' -- 证件状态代码
    ,'1' -- 主证件号标志
    ,'-' -- 联网核查标志
    ,'-' -- 联网核查结果代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_rel_per_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_per_rel_per_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and (trim(p1.rela_cert_type_cd) is not null 
          and trim(p1.rela_cert_num) is not null)
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_party_cert_info_h_eifsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,sorc_sys_cd
  	                                        ,cert_type_cd
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_cert_info_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_cert_info_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sorc_sys_cd, o.sorc_sys_cd) as sorc_sys_cd -- 源系统代码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_num, o.cert_num) as cert_num -- 证件号码
    ,nvl(n.cert_addr, o.cert_addr) as cert_addr -- 证件地址
    ,nvl(n.issue_cert_org, o.issue_cert_org) as issue_cert_org -- 发证机关
    ,nvl(n.issue_cert_org_cty_cd, o.issue_cert_org_cty_cd) as issue_cert_org_cty_cd -- 发证机关国家代码
    ,nvl(n.cert_effect_dt, o.cert_effect_dt) as cert_effect_dt -- 证件生效日期
    ,nvl(n.cert_invalid_dt, o.cert_invalid_dt) as cert_invalid_dt -- 证件失效日期
    ,nvl(n.licen_issue_autho_dist_cd, o.licen_issue_autho_dist_cd) as licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,nvl(n.crdt_cd_cert_id, o.crdt_cd_cert_id) as crdt_cd_cert_id -- 信用代码证编号
    ,nvl(n.cert_valid_flg, o.cert_valid_flg) as cert_valid_flg -- 证件有效标志
    ,nvl(n.cert_status_cd, o.cert_status_cd) as cert_status_cd -- 证件状态代码
    ,nvl(n.main_cert_no_flg, o.main_cert_no_flg) as main_cert_no_flg -- 主证件号标志
    ,nvl(n.netw_vrfction_flg, o.netw_vrfction_flg) as netw_vrfction_flg -- 联网核查标志
    ,nvl(n.netw_vrfction_rest_cd, o.netw_vrfction_rest_cd) as netw_vrfction_rest_cd -- 联网核查结果代码
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
            and n.cert_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
            and n.cert_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
            and n.cert_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_cert_info_h_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_party_cert_info_h_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
            and o.cert_type_cd = n.cert_type_cd
where (
        o.party_id is null
        and o.lp_id is null
        and o.sorc_sys_cd is null
        and o.cert_type_cd is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.sorc_sys_cd is null
        and n.cert_type_cd is null
    )
    or (
        o.cert_num <> n.cert_num
        or o.cert_addr <> n.cert_addr
        or o.issue_cert_org <> n.issue_cert_org
        or o.issue_cert_org_cty_cd <> n.issue_cert_org_cty_cd
        or o.cert_effect_dt <> n.cert_effect_dt
        or o.cert_invalid_dt <> n.cert_invalid_dt
        or o.licen_issue_autho_dist_cd <> n.licen_issue_autho_dist_cd
        or o.crdt_cd_cert_id <> n.crdt_cd_cert_id
        or o.cert_valid_flg <> n.cert_valid_flg
        or o.cert_status_cd <> n.cert_status_cd
        or o.main_cert_no_flg <> n.main_cert_no_flg
        or o.netw_vrfction_flg <> n.netw_vrfction_flg
        or o.netw_vrfction_rest_cd <> n.netw_vrfction_rest_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_cert_info_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_cert_info_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cert_type_cd -- 证件类型代码
    ,cert_num -- 证件号码
    ,cert_addr -- 证件地址
    ,issue_cert_org -- 发证机关
    ,issue_cert_org_cty_cd -- 发证机关国家代码
    ,cert_effect_dt -- 证件生效日期
    ,cert_invalid_dt -- 证件失效日期
    ,licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,crdt_cd_cert_id -- 信用代码证编号
    ,cert_valid_flg -- 证件有效标志
    ,cert_status_cd -- 证件状态代码
    ,main_cert_no_flg -- 主证件号标志
    ,netw_vrfction_flg -- 联网核查标志
    ,netw_vrfction_rest_cd -- 联网核查结果代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.sorc_sys_cd -- 源系统代码
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_num -- 证件号码
    ,o.cert_addr -- 证件地址
    ,o.issue_cert_org -- 发证机关
    ,o.issue_cert_org_cty_cd -- 发证机关国家代码
    ,o.cert_effect_dt -- 证件生效日期
    ,o.cert_invalid_dt -- 证件失效日期
    ,o.licen_issue_autho_dist_cd -- 发证机关行政区划代码
    ,o.crdt_cd_cert_id -- 信用代码证编号
    ,o.cert_valid_flg -- 证件有效标志
    ,o.cert_status_cd -- 证件状态代码
    ,o.main_cert_no_flg -- 主证件号标志
    ,o.netw_vrfction_flg -- 联网核查标志
    ,o.netw_vrfction_rest_cd -- 联网核查结果代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_cert_info_h_eifsf1_bk o
    left join ${iml_schema}.pty_party_cert_info_h_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
            and o.cert_type_cd = n.cert_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_party_cert_info_h_eifsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.sorc_sys_cd = d.sorc_sys_cd
            and o.cert_type_cd = d.cert_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_party_cert_info_h;
--alter table ${iml_schema}.pty_party_cert_info_h truncate partition for ('eifsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_party_cert_info_h') 
               and substr(subpartition_name,1,8)=upper('p_eifsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_party_cert_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_party_cert_info_h modify partition p_eifsf1 
add subpartition p_eifsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

whenever sqlerror exit sql.sqlcode;
-- 4.3 exchange partition
alter table ${iml_schema}.pty_party_cert_info_h exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_party_cert_info_h_eifsf1_cl;
alter table ${iml_schema}.pty_party_cert_info_h exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_party_cert_info_h_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_party_cert_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_party_cert_info_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_cert_info_h_eifsf1_op purge;
drop table ${iml_schema}.pty_party_cert_info_h_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_party_cert_info_h_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_party_cert_info_h', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
