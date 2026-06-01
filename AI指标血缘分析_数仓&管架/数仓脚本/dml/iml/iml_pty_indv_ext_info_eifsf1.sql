/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_indv_ext_info_eifsf1
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
alter table ${iml_schema}.pty_indv_ext_info add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_indv_ext_info_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv_ext_info partition for ('eifsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_indv_ext_info_eifsf1_tm purge;
drop table ${iml_schema}.pty_indv_ext_info_eifsf1_op purge;
drop table ${iml_schema}.pty_indv_ext_info_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_indv_ext_info_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,risk_estim_level_cd -- 客户风险承受能力评估等级代码
    ,risk_estim_valid_tm -- 风险评估有效时间
    ,cmplt_cnter_risk_estim_flg -- 完成柜面风险评估标志
    ,risk_estim_quesn_edit_id -- 风险评估问卷版本编号
    ,risk_estim_quesn_scor -- 风险评估问卷得分
    ,risk_estim_update_tm -- 风险评估更新时间
    ,risk_estim_chn_cd -- 风险评估渠道代码
    ,use_camp_wish_flg -- 使用营销意愿标志
    ,qual_invtor_cert_flg -- 合格投资者认证标志
    ,qual_invtor_vlid_tenor -- 合格投资者有效期限
    ,qual_invtor_src_chn_cd -- 合格投资者来源渠道代码
    ,create_teller_id -- 创建柜员编号
    ,create_org_id -- 创建机构编号
    ,create_chn_cd -- 创建渠道代码
    ,curr_cd -- 币种代码
    ,indus_type_cd -- 行业类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv_ext_info partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_indv_ext_info_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv_ext_info partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_indv_ext_info_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv_ext_info partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_t01_per_cust_ext_info-
insert into ${iml_schema}.pty_indv_ext_info_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,risk_estim_level_cd -- 客户风险承受能力评估等级代码
    ,risk_estim_valid_tm -- 风险评估有效时间
    ,cmplt_cnter_risk_estim_flg -- 完成柜面风险评估标志
    ,risk_estim_quesn_edit_id -- 风险评估问卷版本编号
    ,risk_estim_quesn_scor -- 风险评估问卷得分
    ,risk_estim_update_tm -- 风险评估更新时间
    ,risk_estim_chn_cd -- 风险评估渠道代码
    ,use_camp_wish_flg -- 使用营销意愿标志
    ,qual_invtor_cert_flg -- 合格投资者认证标志
    ,qual_invtor_vlid_tenor -- 合格投资者有效期限
    ,qual_invtor_src_chn_cd -- 合格投资者来源渠道代码
    ,create_teller_id -- 创建柜员编号
    ,create_org_id -- 创建机构编号
    ,create_chn_cd -- 创建渠道代码
    ,curr_cd -- 币种代码
    ,indus_type_cd -- 行业类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p2.cust_num -- 当事人编号
    ,'9999' -- 法人编号
    ,nvl(trim(p1.CUST_RISK_LEVEL),'-') -- 客户风险承受能力评估等级代码
    ,p1.RISK_VALIDITY_PERIOD -- 风险评估有效时间
    ,p1.RISK_ASSESSMENT_COMPLETED -- 完成柜面风险评估标志
    ,p1.RISK_ASSESSMENT_VERSION -- 风险评估问卷版本编号
    ,to_number(NVL(trim(p1.RISK_ESTIM_SCORE),'0')) -- 风险评估问卷得分
    ,p1.RISK_UPDATE_TS -- 风险评估更新时间
    ,nvl(trim(p1.RISK_UPDATE_TE),'-') -- 风险评估渠道代码
    ,p1.SEND_MARKETING_SMS_FLAG -- 使用营销意愿标志
    ,p1.ELIG_INVE_CERT_FLG -- 合格投资者认证标志
    ,p1.ELIG_INVE_VALIDPER -- 合格投资者有效期限
    ,nvl(trim(p1.ELIG_INVE_SRC_CHN),'-') -- 合格投资者来源渠道代码
    ,p1.CREATE_TE -- 创建柜员编号
    ,p1.CREATE_ORG -- 创建机构编号
    ,nvl(trim(p1.INIT_SYSTEM_ID),'-') -- 创建渠道代码
    ,nvl(trim(p1.REVENUE_CURRENCY),'-') -- 币种代码
    ,nvl(trim(p1.BELONG_INDUS_CD),'-') -- 行业类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_cust_ext_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY party_id ORDER BY updated_ts DESC) RN
      FROM ${iol_schema}.eifs_t01_per_cust_ext_info T
			where t.start_dt<= to_date('${batch_date}','yyyymmdd') 
      and t.end_dt > to_date('${batch_date}','yyyymmdd')) p1
    left join ${iol_schema}.eifs_t00_per_cust_no_ref p2 on p1.PARTY_ID = p2.PARTY_ID  AND  P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
where p1.rn=1 
-- and p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_indv_ext_info_eifsf1_tm 
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
        into ${iml_schema}.pty_indv_ext_info_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,risk_estim_level_cd -- 客户风险承受能力评估等级代码
    ,risk_estim_valid_tm -- 风险评估有效时间
    ,cmplt_cnter_risk_estim_flg -- 完成柜面风险评估标志
    ,risk_estim_quesn_edit_id -- 风险评估问卷版本编号
    ,risk_estim_quesn_scor -- 风险评估问卷得分
    ,risk_estim_update_tm -- 风险评估更新时间
    ,risk_estim_chn_cd -- 风险评估渠道代码
    ,use_camp_wish_flg -- 使用营销意愿标志
    ,qual_invtor_cert_flg -- 合格投资者认证标志
    ,qual_invtor_vlid_tenor -- 合格投资者有效期限
    ,qual_invtor_src_chn_cd -- 合格投资者来源渠道代码
    ,create_teller_id -- 创建柜员编号
    ,create_org_id -- 创建机构编号
    ,create_chn_cd -- 创建渠道代码
    ,curr_cd -- 币种代码
    ,indus_type_cd -- 行业类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_indv_ext_info_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,risk_estim_level_cd -- 客户风险承受能力评估等级代码
    ,risk_estim_valid_tm -- 风险评估有效时间
    ,cmplt_cnter_risk_estim_flg -- 完成柜面风险评估标志
    ,risk_estim_quesn_edit_id -- 风险评估问卷版本编号
    ,risk_estim_quesn_scor -- 风险评估问卷得分
    ,risk_estim_update_tm -- 风险评估更新时间
    ,risk_estim_chn_cd -- 风险评估渠道代码
    ,use_camp_wish_flg -- 使用营销意愿标志
    ,qual_invtor_cert_flg -- 合格投资者认证标志
    ,qual_invtor_vlid_tenor -- 合格投资者有效期限
    ,qual_invtor_src_chn_cd -- 合格投资者来源渠道代码
    ,create_teller_id -- 创建柜员编号
    ,create_org_id -- 创建机构编号
    ,create_chn_cd -- 创建渠道代码
    ,curr_cd -- 币种代码
    ,indus_type_cd -- 行业类型代码
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
    ,nvl(n.risk_estim_level_cd, o.risk_estim_level_cd) as risk_estim_level_cd -- 客户风险承受能力评估等级代码
    ,nvl(n.risk_estim_valid_tm, o.risk_estim_valid_tm) as risk_estim_valid_tm -- 风险评估有效时间
    ,nvl(n.cmplt_cnter_risk_estim_flg, o.cmplt_cnter_risk_estim_flg) as cmplt_cnter_risk_estim_flg -- 完成柜面风险评估标志
    ,nvl(n.risk_estim_quesn_edit_id, o.risk_estim_quesn_edit_id) as risk_estim_quesn_edit_id -- 风险评估问卷版本编号
    ,nvl(n.risk_estim_quesn_scor, o.risk_estim_quesn_scor) as risk_estim_quesn_scor -- 风险评估问卷得分
    ,nvl(n.risk_estim_update_tm, o.risk_estim_update_tm) as risk_estim_update_tm -- 风险评估更新时间
    ,nvl(n.risk_estim_chn_cd, o.risk_estim_chn_cd) as risk_estim_chn_cd -- 风险评估渠道代码
    ,nvl(n.use_camp_wish_flg, o.use_camp_wish_flg) as use_camp_wish_flg -- 使用营销意愿标志
    ,nvl(n.qual_invtor_cert_flg, o.qual_invtor_cert_flg) as qual_invtor_cert_flg -- 合格投资者认证标志
    ,nvl(n.qual_invtor_vlid_tenor, o.qual_invtor_vlid_tenor) as qual_invtor_vlid_tenor -- 合格投资者有效期限
    ,nvl(n.qual_invtor_src_chn_cd, o.qual_invtor_src_chn_cd) as qual_invtor_src_chn_cd -- 合格投资者来源渠道代码
    ,nvl(n.create_teller_id, o.create_teller_id) as create_teller_id -- 创建柜员编号
    ,nvl(n.create_org_id, o.create_org_id) as create_org_id -- 创建机构编号
    ,nvl(n.create_chn_cd, o.create_chn_cd) as create_chn_cd -- 创建渠道代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
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
from ${iml_schema}.pty_indv_ext_info_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_indv_ext_info_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.risk_estim_level_cd <> n.risk_estim_level_cd
        or o.risk_estim_valid_tm <> n.risk_estim_valid_tm
        or o.cmplt_cnter_risk_estim_flg <> n.cmplt_cnter_risk_estim_flg
        or o.risk_estim_quesn_edit_id <> n.risk_estim_quesn_edit_id
        or o.risk_estim_quesn_scor <> n.risk_estim_quesn_scor
        or o.risk_estim_update_tm <> n.risk_estim_update_tm
        or o.risk_estim_chn_cd <> n.risk_estim_chn_cd
        or o.use_camp_wish_flg <> n.use_camp_wish_flg
        or o.qual_invtor_cert_flg <> n.qual_invtor_cert_flg
        or o.qual_invtor_vlid_tenor <> n.qual_invtor_vlid_tenor
        or o.qual_invtor_src_chn_cd <> n.qual_invtor_src_chn_cd
        or o.create_teller_id <> n.create_teller_id
        or o.create_org_id <> n.create_org_id
        or o.create_chn_cd <> n.create_chn_cd
        or o.curr_cd <> n.curr_cd
        or o.indus_type_cd <> n.indus_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_indv_ext_info_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,risk_estim_level_cd -- 客户风险承受能力评估等级代码
    ,risk_estim_valid_tm -- 风险评估有效时间
    ,cmplt_cnter_risk_estim_flg -- 完成柜面风险评估标志
    ,risk_estim_quesn_edit_id -- 风险评估问卷版本编号
    ,risk_estim_quesn_scor -- 风险评估问卷得分
    ,risk_estim_update_tm -- 风险评估更新时间
    ,risk_estim_chn_cd -- 风险评估渠道代码
    ,use_camp_wish_flg -- 使用营销意愿标志
    ,qual_invtor_cert_flg -- 合格投资者认证标志
    ,qual_invtor_vlid_tenor -- 合格投资者有效期限
    ,qual_invtor_src_chn_cd -- 合格投资者来源渠道代码
    ,create_teller_id -- 创建柜员编号
    ,create_org_id -- 创建机构编号
    ,create_chn_cd -- 创建渠道代码
    ,curr_cd -- 币种代码
    ,indus_type_cd -- 行业类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_indv_ext_info_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,risk_estim_level_cd -- 客户风险承受能力评估等级代码
    ,risk_estim_valid_tm -- 风险评估有效时间
    ,cmplt_cnter_risk_estim_flg -- 完成柜面风险评估标志
    ,risk_estim_quesn_edit_id -- 风险评估问卷版本编号
    ,risk_estim_quesn_scor -- 风险评估问卷得分
    ,risk_estim_update_tm -- 风险评估更新时间
    ,risk_estim_chn_cd -- 风险评估渠道代码
    ,use_camp_wish_flg -- 使用营销意愿标志
    ,qual_invtor_cert_flg -- 合格投资者认证标志
    ,qual_invtor_vlid_tenor -- 合格投资者有效期限
    ,qual_invtor_src_chn_cd -- 合格投资者来源渠道代码
    ,create_teller_id -- 创建柜员编号
    ,create_org_id -- 创建机构编号
    ,create_chn_cd -- 创建渠道代码
    ,curr_cd -- 币种代码
    ,indus_type_cd -- 行业类型代码
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
    ,o.risk_estim_level_cd -- 客户风险承受能力评估等级代码
    ,o.risk_estim_valid_tm -- 风险评估有效时间
    ,o.cmplt_cnter_risk_estim_flg -- 完成柜面风险评估标志
    ,o.risk_estim_quesn_edit_id -- 风险评估问卷版本编号
    ,o.risk_estim_quesn_scor -- 风险评估问卷得分
    ,o.risk_estim_update_tm -- 风险评估更新时间
    ,o.risk_estim_chn_cd -- 风险评估渠道代码
    ,o.use_camp_wish_flg -- 使用营销意愿标志
    ,o.qual_invtor_cert_flg -- 合格投资者认证标志
    ,o.qual_invtor_vlid_tenor -- 合格投资者有效期限
    ,o.qual_invtor_src_chn_cd -- 合格投资者来源渠道代码
    ,o.create_teller_id -- 创建柜员编号
    ,o.create_org_id -- 创建机构编号
    ,o.create_chn_cd -- 创建渠道代码
    ,o.curr_cd -- 币种代码
    ,o.indus_type_cd -- 行业类型代码
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
from ${iml_schema}.pty_indv_ext_info_eifsf1_bk o
    left join ${iml_schema}.pty_indv_ext_info_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_indv_ext_info_eifsf1_cl d
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
--truncate table ${iml_schema}.pty_indv_ext_info;
--alter table ${iml_schema}.pty_indv_ext_info truncate partition for ('eifsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_indv_ext_info') 
               and substr(subpartition_name,1,8)=upper('p_eifsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_indv_ext_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_indv_ext_info modify partition p_eifsf1 
add subpartition p_eifsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

whenever sqlerror exit sql.sqlcode;
-- 4.3 exchange partition
alter table ${iml_schema}.pty_indv_ext_info exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_indv_ext_info_eifsf1_cl;
alter table ${iml_schema}.pty_indv_ext_info exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_indv_ext_info_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_indv_ext_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_indv_ext_info_eifsf1_tm purge;
drop table ${iml_schema}.pty_indv_ext_info_eifsf1_op purge;
drop table ${iml_schema}.pty_indv_ext_info_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_indv_ext_info_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_indv_ext_info', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
