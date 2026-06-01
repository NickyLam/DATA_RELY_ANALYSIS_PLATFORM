/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_party_rela_ps_h_icmsf1
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
alter table ${iml_schema}.pty_party_rela_ps_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_party_rela_ps_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_rela_ps_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_party_rela_ps_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_party_rela_ps_h_icmsf1_op purge;
drop table ${iml_schema}.pty_party_rela_ps_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_rela_ps_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,rela_ps_rela_type_cd -- 关联人关系类型代码
    ,rela_ps_join_work_tm -- 关联人参加工作时间
    ,rela_ps_corp_phone -- 关联人单位联系电话
    ,rela_ps_tel_num -- 关联人电话号码
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_name -- 关联人名称
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_mon_inco -- 关联人月收入
    ,rela_ps_cert_no -- 关联人证件号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_title_cd -- 关联人职称代码
    ,rela_ps_post_cd -- 关联人职务代码
    ,rela_ps_career_cd -- 关联人职业代码
    ,cty_rg_cd -- 国家和地区代码
    ,rela_ps_zip_cd -- 关联人邮政编码
    ,seq_num -- 序号
    ,spouse_is_have_work -- 配偶是否有工作
    ,rela_ps_phys_addr -- 关联人物理地址
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_rela_ps_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_party_rela_ps_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_rela_ps_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_party_rela_ps_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_rela_ps_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_ent_info-mcompanyname
insert into ${iml_schema}.pty_party_rela_ps_h_icmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,rela_ps_rela_type_cd -- 关联人关系类型代码
    ,rela_ps_join_work_tm -- 关联人参加工作时间
    ,rela_ps_corp_phone -- 关联人单位联系电话
    ,rela_ps_tel_num -- 关联人电话号码
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_name -- 关联人名称
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_mon_inco -- 关联人月收入
    ,rela_ps_cert_no -- 关联人证件号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_title_cd -- 关联人职称代码
    ,rela_ps_post_cd -- 关联人职务代码
    ,rela_ps_career_cd -- 关联人职业代码
    ,cty_rg_cd -- 国家和地区代码
    ,rela_ps_zip_cd -- 关联人邮政编码
    ,seq_num -- 序号
    ,spouse_is_have_work -- 配偶是否有工作
    ,rela_ps_phys_addr -- 关联人物理地址
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUSTOMERID -- 当事人编号
    ,'9999' -- 法人编号
    ,'ICMS' -- 源系统代码
    ,'10111' -- 关联人关系类型代码
    ,${iml_schema}.DATEFORMAT_MIN(NULL) -- 关联人参加工作时间
    ,' ' -- 关联人单位联系电话
    ,' ' -- 关联人电话号码
    ,' ' -- 关联人单位名称
    ,P1.MCOMPANYNAME -- 关联人名称
    ,' ' -- 关联人手机号码
    ,' ' -- 关联人性别代码
    ,0.0 -- 关联人月收入
    ,P1.MCOMPANYCERTID -- 关联人证件号码
    ,nvl(trim(P1.MCOMPANYCERTTYPE),'0000') -- 关联人证件类型代码
    ,' ' -- 关联人职称代码
    ,' ' -- 关联人职务代码
    ,'-' -- 关联人职业代码
    ,'XXX' -- 国家和地区代码
    ,' ' -- 关联人邮政编码
    ,'1' -- 序号
    ,' ' -- 配偶是否有工作
    ,' ' -- 关联人物理地址
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ent_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ent_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- icms_ent_info-supercorpname
insert into ${iml_schema}.pty_party_rela_ps_h_icmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,rela_ps_rela_type_cd -- 关联人关系类型代码
    ,rela_ps_join_work_tm -- 关联人参加工作时间
    ,rela_ps_corp_phone -- 关联人单位联系电话
    ,rela_ps_tel_num -- 关联人电话号码
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_name -- 关联人名称
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_mon_inco -- 关联人月收入
    ,rela_ps_cert_no -- 关联人证件号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_title_cd -- 关联人职称代码
    ,rela_ps_post_cd -- 关联人职务代码
    ,rela_ps_career_cd -- 关联人职业代码
    ,cty_rg_cd -- 国家和地区代码
    ,rela_ps_zip_cd -- 关联人邮政编码
    ,seq_num -- 序号
    ,spouse_is_have_work -- 配偶是否有工作
    ,rela_ps_phys_addr -- 关联人物理地址
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUSTOMERID -- 当事人编号
    ,'9999' -- 法人编号
    ,'ICMS' -- 源系统代码
    ,'10301' -- 关联人关系类型代码
    ,${iml_schema}.DATEFORMAT_MIN(NULL) -- 关联人参加工作时间
    ,' ' -- 关联人单位联系电话
    ,' ' -- 关联人电话号码
    ,' ' -- 关联人单位名称
    ,P1.SUPERCORPNAME -- 关联人名称
    ,' ' -- 关联人手机号码
    ,' ' -- 关联人性别代码
    ,0.0 -- 关联人月收入
    ,P1.SUPERLOANCARDNO -- 关联人证件号码
    ,nvl(trim(P1.SUPERCERTTYPE),'0000') -- 关联人证件类型代码
    ,' ' -- 关联人职称代码
    ,' ' -- 关联人职务代码
    ,'-' -- 关联人职业代码
    ,'XXX' -- 国家和地区代码
    ,' ' -- 关联人邮政编码
    ,'1' -- 序号
    ,' ' -- 配偶是否有工作
    ,' ' -- 关联人物理地址
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ent_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ent_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- icms_ent_info-fictitiousperson
insert into ${iml_schema}.pty_party_rela_ps_h_icmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,rela_ps_rela_type_cd -- 关联人关系类型代码
    ,rela_ps_join_work_tm -- 关联人参加工作时间
    ,rela_ps_corp_phone -- 关联人单位联系电话
    ,rela_ps_tel_num -- 关联人电话号码
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_name -- 关联人名称
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_mon_inco -- 关联人月收入
    ,rela_ps_cert_no -- 关联人证件号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_title_cd -- 关联人职称代码
    ,rela_ps_post_cd -- 关联人职务代码
    ,rela_ps_career_cd -- 关联人职业代码
    ,cty_rg_cd -- 国家和地区代码
    ,rela_ps_zip_cd -- 关联人邮政编码
    ,seq_num -- 序号
    ,spouse_is_have_work -- 配偶是否有工作
    ,rela_ps_phys_addr -- 关联人物理地址
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUSTOMERID -- 当事人编号
    ,'9999' -- 法人编号
    ,'ICMS' -- 源系统代码
    ,'30101' -- 关联人关系类型代码
    ,${iml_schema}.DATEFORMAT_MIN(NULL) -- 关联人参加工作时间
    ,' ' -- 关联人单位联系电话
    ,' ' -- 关联人电话号码
    ,' ' -- 关联人单位名称
    ,P1.FICTITIOUSPERSON -- 关联人名称
    ,P1.FICTITIOUSMOBILE -- 关联人手机号码
    ,' ' -- 关联人性别代码
    ,0.0 -- 关联人月收入
    ,P1.FICTITIOUSPERSONID -- 关联人证件号码
    ,'0000' -- 关联人证件类型代码
    ,' ' -- 关联人职称代码
    ,' ' -- 关联人职务代码
    ,'-' -- 关联人职业代码
    ,'XXX' -- 国家和地区代码
    ,' ' -- 关联人邮政编码
    ,'1' -- 序号
    ,' ' -- 配偶是否有工作
    ,' ' -- 关联人物理地址
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ent_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ent_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- icms_ent_info-financedirectorname
insert into ${iml_schema}.pty_party_rela_ps_h_icmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,rela_ps_rela_type_cd -- 关联人关系类型代码
    ,rela_ps_join_work_tm -- 关联人参加工作时间
    ,rela_ps_corp_phone -- 关联人单位联系电话
    ,rela_ps_tel_num -- 关联人电话号码
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_name -- 关联人名称
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_mon_inco -- 关联人月收入
    ,rela_ps_cert_no -- 关联人证件号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_title_cd -- 关联人职称代码
    ,rela_ps_post_cd -- 关联人职务代码
    ,rela_ps_career_cd -- 关联人职业代码
    ,cty_rg_cd -- 国家和地区代码
    ,rela_ps_zip_cd -- 关联人邮政编码
    ,seq_num -- 序号
    ,spouse_is_have_work -- 配偶是否有工作
    ,rela_ps_phys_addr -- 关联人物理地址
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUSTOMERID -- 当事人编号
    ,'9999' -- 法人编号
    ,'ICMS' -- 源系统代码
    ,'30105' -- 关联人关系类型代码
    ,${iml_schema}.DATEFORMAT_MIN(NULL) -- 关联人参加工作时间
    ,' ' -- 关联人单位联系电话
    ,P1.FINANCEFIAMTEL -- 关联人电话号码
    ,' ' -- 关联人单位名称
    ,P1.FINANCEDIRECTORNAME -- 关联人名称
    ,P1.MOBILEPHONE -- 关联人手机号码
    ,' ' -- 关联人性别代码
    ,0.0 -- 关联人月收入
    ,' ' -- 关联人证件号码
    ,'0000' -- 关联人证件类型代码
    ,' ' -- 关联人职称代码
    ,' ' -- 关联人职务代码
    ,'-' -- 关联人职业代码
    ,'XXX' -- 国家和地区代码
    ,' ' -- 关联人邮政编码
    ,'1' -- 序号
    ,' ' -- 配偶是否有工作
    ,' ' -- 关联人物理地址
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ent_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ent_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_party_rela_ps_h_icmsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,sorc_sys_cd
  	                                        ,rela_ps_rela_type_cd
  	                                        ,seq_num
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
        into ${iml_schema}.pty_party_rela_ps_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,rela_ps_rela_type_cd -- 关联人关系类型代码
    ,rela_ps_join_work_tm -- 关联人参加工作时间
    ,rela_ps_corp_phone -- 关联人单位联系电话
    ,rela_ps_tel_num -- 关联人电话号码
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_name -- 关联人名称
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_mon_inco -- 关联人月收入
    ,rela_ps_cert_no -- 关联人证件号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_title_cd -- 关联人职称代码
    ,rela_ps_post_cd -- 关联人职务代码
    ,rela_ps_career_cd -- 关联人职业代码
    ,cty_rg_cd -- 国家和地区代码
    ,rela_ps_zip_cd -- 关联人邮政编码
    ,seq_num -- 序号
    ,spouse_is_have_work -- 配偶是否有工作
    ,rela_ps_phys_addr -- 关联人物理地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_rela_ps_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,rela_ps_rela_type_cd -- 关联人关系类型代码
    ,rela_ps_join_work_tm -- 关联人参加工作时间
    ,rela_ps_corp_phone -- 关联人单位联系电话
    ,rela_ps_tel_num -- 关联人电话号码
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_name -- 关联人名称
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_mon_inco -- 关联人月收入
    ,rela_ps_cert_no -- 关联人证件号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_title_cd -- 关联人职称代码
    ,rela_ps_post_cd -- 关联人职务代码
    ,rela_ps_career_cd -- 关联人职业代码
    ,cty_rg_cd -- 国家和地区代码
    ,rela_ps_zip_cd -- 关联人邮政编码
    ,seq_num -- 序号
    ,spouse_is_have_work -- 配偶是否有工作
    ,rela_ps_phys_addr -- 关联人物理地址
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
    ,nvl(n.rela_ps_rela_type_cd, o.rela_ps_rela_type_cd) as rela_ps_rela_type_cd -- 关联人关系类型代码
    ,nvl(n.rela_ps_join_work_tm, o.rela_ps_join_work_tm) as rela_ps_join_work_tm -- 关联人参加工作时间
    ,nvl(n.rela_ps_corp_phone, o.rela_ps_corp_phone) as rela_ps_corp_phone -- 关联人单位联系电话
    ,nvl(n.rela_ps_tel_num, o.rela_ps_tel_num) as rela_ps_tel_num -- 关联人电话号码
    ,nvl(n.rela_ps_corp_name, o.rela_ps_corp_name) as rela_ps_corp_name -- 关联人单位名称
    ,nvl(n.rela_ps_name, o.rela_ps_name) as rela_ps_name -- 关联人名称
    ,nvl(n.rela_ps_mobile_no, o.rela_ps_mobile_no) as rela_ps_mobile_no -- 关联人手机号码
    ,nvl(n.rela_ps_gender_cd, o.rela_ps_gender_cd) as rela_ps_gender_cd -- 关联人性别代码
    ,nvl(n.rela_ps_mon_inco, o.rela_ps_mon_inco) as rela_ps_mon_inco -- 关联人月收入
    ,nvl(n.rela_ps_cert_no, o.rela_ps_cert_no) as rela_ps_cert_no -- 关联人证件号码
    ,nvl(n.rela_ps_cert_type_cd, o.rela_ps_cert_type_cd) as rela_ps_cert_type_cd -- 关联人证件类型代码
    ,nvl(n.rela_ps_title_cd, o.rela_ps_title_cd) as rela_ps_title_cd -- 关联人职称代码
    ,nvl(n.rela_ps_post_cd, o.rela_ps_post_cd) as rela_ps_post_cd -- 关联人职务代码
    ,nvl(n.rela_ps_career_cd, o.rela_ps_career_cd) as rela_ps_career_cd -- 关联人职业代码
    ,nvl(n.cty_rg_cd, o.cty_rg_cd) as cty_rg_cd -- 国家和地区代码
    ,nvl(n.rela_ps_zip_cd, o.rela_ps_zip_cd) as rela_ps_zip_cd -- 关联人邮政编码
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.spouse_is_have_work, o.spouse_is_have_work) as spouse_is_have_work -- 配偶是否有工作
    ,nvl(n.rela_ps_phys_addr, o.rela_ps_phys_addr) as rela_ps_phys_addr -- 关联人物理地址
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
            and n.rela_ps_rela_type_cd is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
            and n.rela_ps_rela_type_cd is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
            and n.rela_ps_rela_type_cd is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_rela_ps_h_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_party_rela_ps_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
            and o.rela_ps_rela_type_cd = n.rela_ps_rela_type_cd
            and o.seq_num = n.seq_num
where (
        o.party_id is null
        and o.lp_id is null
        and o.sorc_sys_cd is null
        and o.rela_ps_rela_type_cd is null
        and o.seq_num is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.sorc_sys_cd is null
        and n.rela_ps_rela_type_cd is null
        and n.seq_num is null
    )
    or (
        o.rela_ps_join_work_tm <> n.rela_ps_join_work_tm
        or o.rela_ps_corp_phone <> n.rela_ps_corp_phone
        or o.rela_ps_tel_num <> n.rela_ps_tel_num
        or o.rela_ps_corp_name <> n.rela_ps_corp_name
        or o.rela_ps_name <> n.rela_ps_name
        or o.rela_ps_mobile_no <> n.rela_ps_mobile_no
        or o.rela_ps_gender_cd <> n.rela_ps_gender_cd
        or o.rela_ps_mon_inco <> n.rela_ps_mon_inco
        or o.rela_ps_cert_no <> n.rela_ps_cert_no
        or o.rela_ps_cert_type_cd <> n.rela_ps_cert_type_cd
        or o.rela_ps_title_cd <> n.rela_ps_title_cd
        or o.rela_ps_post_cd <> n.rela_ps_post_cd
        or o.rela_ps_career_cd <> n.rela_ps_career_cd
        or o.cty_rg_cd <> n.cty_rg_cd
        or o.rela_ps_zip_cd <> n.rela_ps_zip_cd
        or o.spouse_is_have_work <> n.spouse_is_have_work
        or o.rela_ps_phys_addr <> n.rela_ps_phys_addr
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_rela_ps_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,rela_ps_rela_type_cd -- 关联人关系类型代码
    ,rela_ps_join_work_tm -- 关联人参加工作时间
    ,rela_ps_corp_phone -- 关联人单位联系电话
    ,rela_ps_tel_num -- 关联人电话号码
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_name -- 关联人名称
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_mon_inco -- 关联人月收入
    ,rela_ps_cert_no -- 关联人证件号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_title_cd -- 关联人职称代码
    ,rela_ps_post_cd -- 关联人职务代码
    ,rela_ps_career_cd -- 关联人职业代码
    ,cty_rg_cd -- 国家和地区代码
    ,rela_ps_zip_cd -- 关联人邮政编码
    ,seq_num -- 序号
    ,spouse_is_have_work -- 配偶是否有工作
    ,rela_ps_phys_addr -- 关联人物理地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_rela_ps_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,rela_ps_rela_type_cd -- 关联人关系类型代码
    ,rela_ps_join_work_tm -- 关联人参加工作时间
    ,rela_ps_corp_phone -- 关联人单位联系电话
    ,rela_ps_tel_num -- 关联人电话号码
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_name -- 关联人名称
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_mon_inco -- 关联人月收入
    ,rela_ps_cert_no -- 关联人证件号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_title_cd -- 关联人职称代码
    ,rela_ps_post_cd -- 关联人职务代码
    ,rela_ps_career_cd -- 关联人职业代码
    ,cty_rg_cd -- 国家和地区代码
    ,rela_ps_zip_cd -- 关联人邮政编码
    ,seq_num -- 序号
    ,spouse_is_have_work -- 配偶是否有工作
    ,rela_ps_phys_addr -- 关联人物理地址
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
    ,o.rela_ps_rela_type_cd -- 关联人关系类型代码
    ,o.rela_ps_join_work_tm -- 关联人参加工作时间
    ,o.rela_ps_corp_phone -- 关联人单位联系电话
    ,o.rela_ps_tel_num -- 关联人电话号码
    ,o.rela_ps_corp_name -- 关联人单位名称
    ,o.rela_ps_name -- 关联人名称
    ,o.rela_ps_mobile_no -- 关联人手机号码
    ,o.rela_ps_gender_cd -- 关联人性别代码
    ,o.rela_ps_mon_inco -- 关联人月收入
    ,o.rela_ps_cert_no -- 关联人证件号码
    ,o.rela_ps_cert_type_cd -- 关联人证件类型代码
    ,o.rela_ps_title_cd -- 关联人职称代码
    ,o.rela_ps_post_cd -- 关联人职务代码
    ,o.rela_ps_career_cd -- 关联人职业代码
    ,o.cty_rg_cd -- 国家和地区代码
    ,o.rela_ps_zip_cd -- 关联人邮政编码
    ,o.seq_num -- 序号
    ,o.spouse_is_have_work -- 配偶是否有工作
    ,o.rela_ps_phys_addr -- 关联人物理地址
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
from ${iml_schema}.pty_party_rela_ps_h_icmsf1_bk o
    left join ${iml_schema}.pty_party_rela_ps_h_icmsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
            and o.rela_ps_rela_type_cd = n.rela_ps_rela_type_cd
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_party_rela_ps_h_icmsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.sorc_sys_cd = d.sorc_sys_cd
            and o.rela_ps_rela_type_cd = d.rela_ps_rela_type_cd
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_party_rela_ps_h;
--alter table ${iml_schema}.pty_party_rela_ps_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_party_rela_ps_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_party_rela_ps_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_party_rela_ps_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_party_rela_ps_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_party_rela_ps_h_icmsf1_cl;
alter table ${iml_schema}.pty_party_rela_ps_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_party_rela_ps_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_party_rela_ps_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_party_rela_ps_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_party_rela_ps_h_icmsf1_op purge;
drop table ${iml_schema}.pty_party_rela_ps_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_party_rela_ps_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_party_rela_ps_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
