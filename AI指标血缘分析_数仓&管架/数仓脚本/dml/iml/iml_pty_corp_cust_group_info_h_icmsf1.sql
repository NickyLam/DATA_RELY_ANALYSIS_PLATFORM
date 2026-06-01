/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_corp_cust_group_info_h_icmsf1
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
alter table ${iml_schema}.pty_corp_cust_group_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_cust_group_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
    ,group_cust_type_cd -- 集团客户类型代码
    ,mem_corp_name -- 成员单位名称
    ,parent_mem_id -- 父成员编号
    ,parent_mem_rela_type_cd -- 父成员关系类型代码
    ,share_ratio -- 持股比例
    ,chg_type_cd -- 修订类型代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_cust_group_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_cust_group_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_cust_group_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_group_member_relative-
insert into ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
    ,group_cust_type_cd -- 集团客户类型代码
    ,mem_corp_name -- 成员单位名称
    ,parent_mem_id -- 父成员编号
    ,parent_mem_rela_type_cd -- 父成员关系类型代码
    ,share_ratio -- 持股比例
    ,chg_type_cd -- 修订类型代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.MEMBERCUSTOMERID -- 当事人编号
    , '9999' -- 法人编号
    ,P1.GROUPID -- 所属集团编号
    ,'ICMS' -- 数据来源代码
    ,P2.GROUPNAME -- 所属集团名称
    , ' ' -- 所属集团组织机构代码
    , ' ' -- 所属集团贷款卡号
    ,nvl(trim(P2.REGISTERREGIONCODE),'-') -- 所属集团注册国家地区代码
    ,P2.CITY -- 所属集团所在地代码
    , ' ' -- 所属集团注册地址
    , ' ' -- 集团核心成员标志
    ,P2.PARENTCOMPANYOFFICEADD -- 所属集团国内办公地址
    ,nvl(trim(P1.MEMBERTYPE),'-') -- 成员类型代码
    ,CASE WHEN P1.MEMBERTYPE='10111' THEN '1' ELSE '0' END  -- 母公司标志
    ,'-' -- 成员状态代码
    ,P2.CURRENTVERSIONSEQ -- 当前使用的家谱版本号
    ,P2.REFVERSIONSEQ -- 当前维护的家谱版本号
    ,nvl(trim(P1.GROUPCUSTOMERTYPE),'-') -- 集团客户类型代码
    ,P1.MEMBERNAME -- 成员单位名称
    ,P1.PARENTMEMBERID -- 父成员编号
    ,nvl(trim(P1.PARENTRELATIONTYPE),'00000') -- 父成员关系类型代码
    ,P1.SHAREVALUE -- 持股比例
    ,nvl(trim(P1.REVISEFLAG),'-') -- 修订类型代码
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_group_member_relative' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_group_member_relative p1
    inner join ${iol_schema}.icms_group_info p2 on p2.GROUPID = p1.GROUPID  AND  P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,belong_group_id
  	                                        ,data_src_cd
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
        into ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
    ,group_cust_type_cd -- 集团客户类型代码
    ,mem_corp_name -- 成员单位名称
    ,parent_mem_id -- 父成员编号
    ,parent_mem_rela_type_cd -- 父成员关系类型代码
    ,share_ratio -- 持股比例
    ,chg_type_cd -- 修订类型代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
    ,group_cust_type_cd -- 集团客户类型代码
    ,mem_corp_name -- 成员单位名称
    ,parent_mem_id -- 父成员编号
    ,parent_mem_rela_type_cd -- 父成员关系类型代码
    ,share_ratio -- 持股比例
    ,chg_type_cd -- 修订类型代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,final_update_dt -- 最后更新日期
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
    ,nvl(n.belong_group_id, o.belong_group_id) as belong_group_id -- 所属集团编号
    ,nvl(n.data_src_cd, o.data_src_cd) as data_src_cd -- 数据来源代码
    ,nvl(n.belong_group_name, o.belong_group_name) as belong_group_name -- 所属集团名称
    ,nvl(n.belong_group_orgnz_cd, o.belong_group_orgnz_cd) as belong_group_orgnz_cd -- 所属集团组织机构代码
    ,nvl(n.belong_group_loan_card_no, o.belong_group_loan_card_no) as belong_group_loan_card_no -- 所属集团贷款卡号
    ,nvl(n.belong_group_rgst_cty_rg_cd, o.belong_group_rgst_cty_rg_cd) as belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,nvl(n.belong_group_site_cd, o.belong_group_site_cd) as belong_group_site_cd -- 所属集团所在地代码
    ,nvl(n.belong_group_rgst_addr, o.belong_group_rgst_addr) as belong_group_rgst_addr -- 所属集团注册地址
    ,nvl(n.group_core_mem_flg, o.group_core_mem_flg) as group_core_mem_flg -- 集团核心成员标志
    ,nvl(n.belong_group_dom_work_addr, o.belong_group_dom_work_addr) as belong_group_dom_work_addr -- 所属集团国内办公地址
    ,nvl(n.mem_type_cd, o.mem_type_cd) as mem_type_cd -- 成员类型代码
    ,nvl(n.parent_corp_flg, o.parent_corp_flg) as parent_corp_flg -- 母公司标志
    ,nvl(n.mem_status_cd, o.mem_status_cd) as mem_status_cd -- 成员状态代码
    ,nvl(n.use_family_edit_num, o.use_family_edit_num) as use_family_edit_num -- 当前使用的家谱版本号
    ,nvl(n.matn_family_edit_num, o.matn_family_edit_num) as matn_family_edit_num -- 当前维护的家谱版本号
    ,nvl(n.group_cust_type_cd, o.group_cust_type_cd) as group_cust_type_cd -- 集团客户类型代码
    ,nvl(n.mem_corp_name, o.mem_corp_name) as mem_corp_name -- 成员单位名称
    ,nvl(n.parent_mem_id, o.parent_mem_id) as parent_mem_id -- 父成员编号
    ,nvl(n.parent_mem_rela_type_cd, o.parent_mem_rela_type_cd) as parent_mem_rela_type_cd -- 父成员关系类型代码
    ,nvl(n.share_ratio, o.share_ratio) as share_ratio -- 持股比例
    ,nvl(n.chg_type_cd, o.chg_type_cd) as chg_type_cd -- 修订类型代码
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.belong_group_id is null
            and n.data_src_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.belong_group_id is null
            and n.data_src_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.belong_group_id is null
            and n.data_src_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.belong_group_id = n.belong_group_id
            and o.data_src_cd = n.data_src_cd
where (
        o.party_id is null
        and o.lp_id is null
        and o.belong_group_id is null
        and o.data_src_cd is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.belong_group_id is null
        and n.data_src_cd is null
    )
    or (
        o.belong_group_name <> n.belong_group_name
        or o.belong_group_orgnz_cd <> n.belong_group_orgnz_cd
        or o.belong_group_loan_card_no <> n.belong_group_loan_card_no
        or o.belong_group_rgst_cty_rg_cd <> n.belong_group_rgst_cty_rg_cd
        or o.belong_group_site_cd <> n.belong_group_site_cd
        or o.belong_group_rgst_addr <> n.belong_group_rgst_addr
        or o.group_core_mem_flg <> n.group_core_mem_flg
        or o.belong_group_dom_work_addr <> n.belong_group_dom_work_addr
        or o.mem_type_cd <> n.mem_type_cd
        or o.parent_corp_flg <> n.parent_corp_flg
        or o.mem_status_cd <> n.mem_status_cd
        or o.use_family_edit_num <> n.use_family_edit_num
        or o.matn_family_edit_num <> n.matn_family_edit_num
        or o.group_cust_type_cd <> n.group_cust_type_cd
        or o.mem_corp_name <> n.mem_corp_name
        or o.parent_mem_id <> n.parent_mem_id
        or o.parent_mem_rela_type_cd <> n.parent_mem_rela_type_cd
        or o.share_ratio <> n.share_ratio
        or o.chg_type_cd <> n.chg_type_cd
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_org_id <> n.update_org_id
        or o.update_teller_id <> n.update_teller_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
    ,group_cust_type_cd -- 集团客户类型代码
    ,mem_corp_name -- 成员单位名称
    ,parent_mem_id -- 父成员编号
    ,parent_mem_rela_type_cd -- 父成员关系类型代码
    ,share_ratio -- 持股比例
    ,chg_type_cd -- 修订类型代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_group_id -- 所属集团编号
    ,data_src_cd -- 数据来源代码
    ,belong_group_name -- 所属集团名称
    ,belong_group_orgnz_cd -- 所属集团组织机构代码
    ,belong_group_loan_card_no -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,belong_group_site_cd -- 所属集团所在地代码
    ,belong_group_rgst_addr -- 所属集团注册地址
    ,group_core_mem_flg -- 集团核心成员标志
    ,belong_group_dom_work_addr -- 所属集团国内办公地址
    ,mem_type_cd -- 成员类型代码
    ,parent_corp_flg -- 母公司标志
    ,mem_status_cd -- 成员状态代码
    ,use_family_edit_num -- 当前使用的家谱版本号
    ,matn_family_edit_num -- 当前维护的家谱版本号
    ,group_cust_type_cd -- 集团客户类型代码
    ,mem_corp_name -- 成员单位名称
    ,parent_mem_id -- 父成员编号
    ,parent_mem_rela_type_cd -- 父成员关系类型代码
    ,share_ratio -- 持股比例
    ,chg_type_cd -- 修订类型代码
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,update_org_id -- 更新机构编号
    ,update_teller_id -- 更新柜员编号
    ,final_update_dt -- 最后更新日期
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
    ,o.belong_group_id -- 所属集团编号
    ,o.data_src_cd -- 数据来源代码
    ,o.belong_group_name -- 所属集团名称
    ,o.belong_group_orgnz_cd -- 所属集团组织机构代码
    ,o.belong_group_loan_card_no -- 所属集团贷款卡号
    ,o.belong_group_rgst_cty_rg_cd -- 所属集团注册国家地区代码
    ,o.belong_group_site_cd -- 所属集团所在地代码
    ,o.belong_group_rgst_addr -- 所属集团注册地址
    ,o.group_core_mem_flg -- 集团核心成员标志
    ,o.belong_group_dom_work_addr -- 所属集团国内办公地址
    ,o.mem_type_cd -- 成员类型代码
    ,o.parent_corp_flg -- 母公司标志
    ,o.mem_status_cd -- 成员状态代码
    ,o.use_family_edit_num -- 当前使用的家谱版本号
    ,o.matn_family_edit_num -- 当前维护的家谱版本号
    ,o.group_cust_type_cd -- 集团客户类型代码
    ,o.mem_corp_name -- 成员单位名称
    ,o.parent_mem_id -- 父成员编号
    ,o.parent_mem_rela_type_cd -- 父成员关系类型代码
    ,o.share_ratio -- 持股比例
    ,o.chg_type_cd -- 修订类型代码
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_dt -- 登记日期
    ,o.update_org_id -- 更新机构编号
    ,o.update_teller_id -- 更新柜员编号
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_bk o
    left join ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.belong_group_id = n.belong_group_id
            and o.data_src_cd = n.data_src_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.belong_group_id = d.belong_group_id
            and o.data_src_cd = d.data_src_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_corp_cust_group_info_h;
--alter table ${iml_schema}.pty_corp_cust_group_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_corp_cust_group_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_corp_cust_group_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_corp_cust_group_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_corp_cust_group_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_cl;
alter table ${iml_schema}.pty_corp_cust_group_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_corp_cust_group_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_corp_cust_group_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_corp_cust_group_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
