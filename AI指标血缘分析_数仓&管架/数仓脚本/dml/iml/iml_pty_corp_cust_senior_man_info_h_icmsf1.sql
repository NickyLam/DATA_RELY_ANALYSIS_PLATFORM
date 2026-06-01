/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_corp_cust_senior_man_info_h_icmsf1
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
alter table ${iml_schema}.pty_corp_cust_senior_man_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_cust_senior_man_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_name -- 当事人名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_rela_type_cd -- 关联关系类型代码
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,edu_cd -- 学历代码
    ,work_resume_descb -- 工作简历描述
    ,phone_num -- 联系电话号码
    ,serving_dt -- 任职日期
    ,indus_obtain_emply_years -- 行业从业年限
    ,hold_stock_situ_descb -- 持股情况描述
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,share_ratio -- 持股比例
    ,title_cd -- 职称代码
    ,work_tel_num -- 单位电话号码
    ,valid_flg -- 有效标志
    ,nation_cd -- 国籍代码
    ,corp_actl_ctrler_flg -- 企业实际控制人标志
    ,senior_man_type_cd -- 高管类型代码
    ,senior_man_career_cd -- 高管职业代码
    ,cust_id -- 客户编号
    ,rela_ps_cust_id -- 关联人客户编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_cust_senior_man_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_cust_senior_man_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_cust_senior_man_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_customer_ship_executives-1
insert into ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_name -- 当事人名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_rela_type_cd -- 关联关系类型代码
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,edu_cd -- 学历代码
    ,work_resume_descb -- 工作简历描述
    ,phone_num -- 联系电话号码
    ,serving_dt -- 任职日期
    ,indus_obtain_emply_years -- 行业从业年限
    ,hold_stock_situ_descb -- 持股情况描述
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,share_ratio -- 持股比例
    ,title_cd -- 职称代码
    ,work_tel_num -- 单位电话号码
    ,valid_flg -- 有效标志
    ,nation_cd -- 国籍代码
    ,corp_actl_ctrler_flg -- 企业实际控制人标志
    ,senior_man_type_cd -- 高管类型代码
    ,senior_man_career_cd -- 高管职业代码
    ,cust_id -- 客户编号
    ,rela_ps_cust_id -- 关联人客户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SERIALNO -- 当事人编号
    , '9999' -- 法人编号
    ,P1.CUSTOMERNAME -- 当事人名称
    ,nvl(trim(P1.CERTTYPE),'0000') -- 证件类型代码
    ,P1.CERTID -- 证件号码
    ,nvl(trim(P1.RELATIONSHIP),'00000')  -- 关联关系类型代码
    ,NVL(TRIM(P1.SEX),'0') -- 性别代码
    ,P1.BIRTHDAY -- 出生日期
    ,nvl(trim(P1.EDUEXPERIENCE),'-') -- 学历代码
    ,P1.RESUME -- 工作简历描述
    ,P1.TELEPHONE -- 联系电话号码
    ,P1.HOLDDATE -- 任职日期
    ,P1.ENGAGETERM -- 行业从业年限
    ,P1.HOLDSTOCK -- 持股情况描述
    ,P1.REMARK -- 备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 变更日期
    ,P1.SHAREVALUE -- 持股比例
    ,nvl(trim(P1.JOBTITLE),'-') -- 职称代码
    ,P1.OFFICEPHONE -- 单位电话号码
    ,DECODE(P1.EFFSTATUS,'1','1','2','0',P1.EFFSTATUS) -- 有效标志
    ,nvl(trim(P1.NTLYCD),'-') -- 国籍代码
    ,nvl(trim(P1.ACTUALCONTROLLER),'-') -- 企业实际控制人标志
    ,P1.EXECUTIVETYPE -- 高管类型代码
    ,P1.PROFESSIONAL -- 高管职业代码
    ,P1.CUSTOMERID -- 客户编号
    ,P1.MAINCUSTOMERID -- 关联人客户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_customer_ship_executives' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_customer_ship_executives p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_tm 
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_name -- 当事人名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_rela_type_cd -- 关联关系类型代码
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,edu_cd -- 学历代码
    ,work_resume_descb -- 工作简历描述
    ,phone_num -- 联系电话号码
    ,serving_dt -- 任职日期
    ,indus_obtain_emply_years -- 行业从业年限
    ,hold_stock_situ_descb -- 持股情况描述
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,share_ratio -- 持股比例
    ,title_cd -- 职称代码
    ,work_tel_num -- 单位电话号码
    ,valid_flg -- 有效标志
    ,nation_cd -- 国籍代码
    ,corp_actl_ctrler_flg -- 企业实际控制人标志
    ,senior_man_type_cd -- 高管类型代码
    ,senior_man_career_cd -- 高管职业代码
    ,cust_id -- 客户编号
    ,rela_ps_cust_id -- 关联人客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_name -- 当事人名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_rela_type_cd -- 关联关系类型代码
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,edu_cd -- 学历代码
    ,work_resume_descb -- 工作简历描述
    ,phone_num -- 联系电话号码
    ,serving_dt -- 任职日期
    ,indus_obtain_emply_years -- 行业从业年限
    ,hold_stock_situ_descb -- 持股情况描述
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,share_ratio -- 持股比例
    ,title_cd -- 职称代码
    ,work_tel_num -- 单位电话号码
    ,valid_flg -- 有效标志
    ,nation_cd -- 国籍代码
    ,corp_actl_ctrler_flg -- 企业实际控制人标志
    ,senior_man_type_cd -- 高管类型代码
    ,senior_man_career_cd -- 高管职业代码
    ,cust_id -- 客户编号
    ,rela_ps_cust_id -- 关联人客户编号
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
    ,nvl(n.party_name, o.party_name) as party_name -- 当事人名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.party_rela_type_cd, o.party_rela_type_cd) as party_rela_type_cd -- 关联关系类型代码
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 出生日期
    ,nvl(n.edu_cd, o.edu_cd) as edu_cd -- 学历代码
    ,nvl(n.work_resume_descb, o.work_resume_descb) as work_resume_descb -- 工作简历描述
    ,nvl(n.phone_num, o.phone_num) as phone_num -- 联系电话号码
    ,nvl(n.serving_dt, o.serving_dt) as serving_dt -- 任职日期
    ,nvl(n.indus_obtain_emply_years, o.indus_obtain_emply_years) as indus_obtain_emply_years -- 行业从业年限
    ,nvl(n.hold_stock_situ_descb, o.hold_stock_situ_descb) as hold_stock_situ_descb -- 持股情况描述
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.share_ratio, o.share_ratio) as share_ratio -- 持股比例
    ,nvl(n.title_cd, o.title_cd) as title_cd -- 职称代码
    ,nvl(n.work_tel_num, o.work_tel_num) as work_tel_num -- 单位电话号码
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.nation_cd, o.nation_cd) as nation_cd -- 国籍代码
    ,nvl(n.corp_actl_ctrler_flg, o.corp_actl_ctrler_flg) as corp_actl_ctrler_flg -- 企业实际控制人标志
    ,nvl(n.senior_man_type_cd, o.senior_man_type_cd) as senior_man_type_cd -- 高管类型代码
    ,nvl(n.senior_man_career_cd, o.senior_man_career_cd) as senior_man_career_cd -- 高管职业代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.rela_ps_cust_id, o.rela_ps_cust_id) as rela_ps_cust_id -- 关联人客户编号
    ,case when
            n.party_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
where (
        o.party_id is null
        and o.lp_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
    )
    or (
        o.party_name <> n.party_name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.party_rela_type_cd <> n.party_rela_type_cd
        or o.gender_cd <> n.gender_cd
        or o.birth_dt <> n.birth_dt
        or o.edu_cd <> n.edu_cd
        or o.work_resume_descb <> n.work_resume_descb
        or o.phone_num <> n.phone_num
        or o.serving_dt <> n.serving_dt
        or o.indus_obtain_emply_years <> n.indus_obtain_emply_years
        or o.hold_stock_situ_descb <> n.hold_stock_situ_descb
        or o.remark <> n.remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_dt <> n.rgst_dt
        or o.rgst_org_id <> n.rgst_org_id
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
        or o.share_ratio <> n.share_ratio
        or o.title_cd <> n.title_cd
        or o.work_tel_num <> n.work_tel_num
        or o.valid_flg <> n.valid_flg
        or o.nation_cd <> n.nation_cd
        or o.corp_actl_ctrler_flg <> n.corp_actl_ctrler_flg
        or o.senior_man_type_cd <> n.senior_man_type_cd
        or o.senior_man_career_cd <> n.senior_man_career_cd
        or o.cust_id <> n.cust_id
        or o.rela_ps_cust_id <> n.rela_ps_cust_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_name -- 当事人名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_rela_type_cd -- 关联关系类型代码
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,edu_cd -- 学历代码
    ,work_resume_descb -- 工作简历描述
    ,phone_num -- 联系电话号码
    ,serving_dt -- 任职日期
    ,indus_obtain_emply_years -- 行业从业年限
    ,hold_stock_situ_descb -- 持股情况描述
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,share_ratio -- 持股比例
    ,title_cd -- 职称代码
    ,work_tel_num -- 单位电话号码
    ,valid_flg -- 有效标志
    ,nation_cd -- 国籍代码
    ,corp_actl_ctrler_flg -- 企业实际控制人标志
    ,senior_man_type_cd -- 高管类型代码
    ,senior_man_career_cd -- 高管职业代码
    ,cust_id -- 客户编号
    ,rela_ps_cust_id -- 关联人客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_name -- 当事人名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_rela_type_cd -- 关联关系类型代码
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,edu_cd -- 学历代码
    ,work_resume_descb -- 工作简历描述
    ,phone_num -- 联系电话号码
    ,serving_dt -- 任职日期
    ,indus_obtain_emply_years -- 行业从业年限
    ,hold_stock_situ_descb -- 持股情况描述
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,share_ratio -- 持股比例
    ,title_cd -- 职称代码
    ,work_tel_num -- 单位电话号码
    ,valid_flg -- 有效标志
    ,nation_cd -- 国籍代码
    ,corp_actl_ctrler_flg -- 企业实际控制人标志
    ,senior_man_type_cd -- 高管类型代码
    ,senior_man_career_cd -- 高管职业代码
    ,cust_id -- 客户编号
    ,rela_ps_cust_id -- 关联人客户编号
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
    ,o.party_name -- 当事人名称
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.party_rela_type_cd -- 关联关系类型代码
    ,o.gender_cd -- 性别代码
    ,o.birth_dt -- 出生日期
    ,o.edu_cd -- 学历代码
    ,o.work_resume_descb -- 工作简历描述
    ,o.phone_num -- 联系电话号码
    ,o.serving_dt -- 任职日期
    ,o.indus_obtain_emply_years -- 行业从业年限
    ,o.hold_stock_situ_descb -- 持股情况描述
    ,o.remark -- 备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_dt -- 登记日期
    ,o.rgst_org_id -- 登记机构编号
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
    ,o.share_ratio -- 持股比例
    ,o.title_cd -- 职称代码
    ,o.work_tel_num -- 单位电话号码
    ,o.valid_flg -- 有效标志
    ,o.nation_cd -- 国籍代码
    ,o.corp_actl_ctrler_flg -- 企业实际控制人标志
    ,o.senior_man_type_cd -- 高管类型代码
    ,o.senior_man_career_cd -- 高管职业代码
    ,o.cust_id -- 客户编号
    ,o.rela_ps_cust_id -- 关联人客户编号
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
from ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_bk o
    left join ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_corp_cust_senior_man_info_h;
--alter table ${iml_schema}.pty_corp_cust_senior_man_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_corp_cust_senior_man_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_corp_cust_senior_man_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_corp_cust_senior_man_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_corp_cust_senior_man_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_cl;
alter table ${iml_schema}.pty_corp_cust_senior_man_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_corp_cust_senior_man_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_corp_cust_senior_man_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_corp_cust_senior_man_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
