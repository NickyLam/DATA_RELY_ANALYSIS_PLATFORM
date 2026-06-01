/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_indv_cust_ifmsf1
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
drop table ${iml_schema}.pty_indv_cust_ifmsf1_tm purge;
drop table ${iml_schema}.pty_indv_cust_ifmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_indv_cust add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_indv_cust modify partition p_ifmsf1
    add subpartition p_ifmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_indv_cust_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv_cust partition for ('ifmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_indv_cust_ifmsf1_tm
compress ${option_switch} for query high
as
select
    cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,nationty_cd -- 民族代码
    ,nati_place -- 籍贯
    ,politic_status_cd -- 政治面貌代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,emply_flg -- 行员标志
    ,age -- 年龄
    ,resdnt_flg -- 居民标志
    ,nation_cd -- 国籍代码
    ,dist_cd -- 行政区域代码
    ,hxb_shard_flg -- 我行股东标志
    ,owner_type_cd -- 客户性质代码
    ,ctysd_rpr_flg -- 农村户口标志
    ,hxb_rela_party_flg -- 我行关联方标志
    ,hxb_trast_inter_bus_flg -- 在我行办理过中间业务标志
    ,hxb_payoff_sal_acct_flg -- 我行代发工资户标志
    ,hxb_reg_cust_flg -- 我行定期客户标志
    ,hxb_finc_cust_flg -- 我行理财客户标志
    ,hxb_vip_cust_idf -- 我行VIP客户标识
    ,spouse_child_img_flg -- 配偶及子女移民标志
    ,enjoy_cty_prefr_policy_flg -- 享受国家优惠政策标志
    ,grad_sch -- 毕业学校
    ,grad_year -- 毕业年份
    ,e_mail -- 电子邮箱
    ,open_acct_teller_id -- 开户柜员编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_dt -- 开户日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv_cust
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_indv_cust_ifmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_indv_cust partition for ('ifmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ifms_tbclient-
insert into ${iml_schema}.pty_indv_cust_ifmsf1_tm(
    cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,nationty_cd -- 民族代码
    ,nati_place -- 籍贯
    ,politic_status_cd -- 政治面貌代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,emply_flg -- 行员标志
    ,age -- 年龄
    ,resdnt_flg -- 居民标志
    ,nation_cd -- 国籍代码
    ,dist_cd -- 行政区域代码
    ,hxb_shard_flg -- 我行股东标志
    ,owner_type_cd -- 客户性质代码
    ,ctysd_rpr_flg -- 农村户口标志
    ,hxb_rela_party_flg -- 我行关联方标志
    ,hxb_trast_inter_bus_flg -- 在我行办理过中间业务标志
    ,hxb_payoff_sal_acct_flg -- 我行代发工资户标志
    ,hxb_reg_cust_flg -- 我行定期客户标志
    ,hxb_finc_cust_flg -- 我行理财客户标志
    ,hxb_vip_cust_idf -- 我行VIP客户标识
    ,spouse_child_img_flg -- 配偶及子女移民标志
    ,enjoy_cty_prefr_policy_flg -- 享受国家优惠政策标志
    ,grad_sch -- 毕业学校
    ,grad_year -- 毕业年份
    ,e_mail -- 电子邮箱
    ,open_acct_teller_id -- 开户柜员编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_dt -- 开户日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.IN_CLIENT_NO -- 客户编号
    ,'9999' -- 法人编号
    ,'IFMS' -- 源系统代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.SEX END -- 性别代码
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.BIRTHDAY)) -- 出生日期
    ,'00' -- 民族代码
    ,' ' -- 籍贯
    ,' ' -- 政治面貌代码
    ,'90' -- 婚姻状况代码
    ,'-' -- 行员标志
    ,0 -- 年龄
    ,' ' -- 居民标志
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.NATIONALITY END -- 国籍代码
    ,'000000' -- 行政区域代码
    ,'-' -- 我行股东标志
    ,'-' -- 客户性质代码
    ,'-' -- 农村户口标志
    ,'-' -- 我行关联方标志
    ,'-' -- 在我行办理过中间业务标志
    ,'-' -- 我行代发工资户标志
    ,'-' -- 我行定期客户标志
    ,'-' -- 我行理财客户标志
    ,'-' -- 我行VIP客户标识
    ,'-' -- 配偶及子女移民标志
    ,'-' -- 享受国家优惠政策标志
    ,' ' -- 毕业学校
    ,null -- 毕业年份
    ,' ' -- 电子邮箱
    ,' ' -- 开户柜员编号
    ,' ' -- 开户机构编号
    ,null -- 开户日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbclient' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.ifms_tbclient p1
  left join ${iml_schema}.ref_pub_cd_map r1
    on p1.sex = r1.src_code_val
   and r1.sorc_sys_cd = 'IFMS'
   and r1.src_tab_en_name = 'IFMS_TBCLIENT'
   and r1.src_field_en_name = 'SEX'
   and r1.target_tab_en_name = 'PTY_INDV_CUST'
   and r1.target_tab_field_en_name = 'GENDER_CD'
  left join ${iml_schema}.ref_pub_cd_map r2
    on p1.nationality = r2.src_code_val
   and r2.sorc_sys_cd = 'IFMS'
   and r2.src_tab_en_name = 'IFMS_TBCLIENT'
   and r2.src_field_en_name = 'NATIONALITY'
   and r2.target_tab_en_name = 'PTY_INDV_CUST'
   and r2.target_tab_field_en_name = 'NATION_CD'
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p1.client_type = '1'
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_indv_cust_ifmsf1_tm 
  	                                group by 
  	                                        cust_id
  	                                        ,lp_id
  	                                        ,sorc_sys_cd
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
insert /*+ append */ into ${iml_schema}.pty_indv_cust_ifmsf1_ex(
    cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,nationty_cd -- 民族代码
    ,nati_place -- 籍贯
    ,politic_status_cd -- 政治面貌代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,emply_flg -- 行员标志
    ,age -- 年龄
    ,resdnt_flg -- 居民标志
    ,nation_cd -- 国籍代码
    ,dist_cd -- 行政区域代码
    ,hxb_shard_flg -- 我行股东标志
    ,owner_type_cd -- 客户性质代码
    ,ctysd_rpr_flg -- 农村户口标志
    ,hxb_rela_party_flg -- 我行关联方标志
    ,hxb_trast_inter_bus_flg -- 在我行办理过中间业务标志
    ,hxb_payoff_sal_acct_flg -- 我行代发工资户标志
    ,hxb_reg_cust_flg -- 我行定期客户标志
    ,hxb_finc_cust_flg -- 我行理财客户标志
    ,hxb_vip_cust_idf -- 我行VIP客户标识
    ,spouse_child_img_flg -- 配偶及子女移民标志
    ,enjoy_cty_prefr_policy_flg -- 享受国家优惠政策标志
    ,grad_sch -- 毕业学校
    ,grad_year -- 毕业年份
    ,e_mail -- 电子邮箱
    ,open_acct_teller_id -- 开户柜员编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_dt -- 开户日期
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sorc_sys_cd, o.sorc_sys_cd) as sorc_sys_cd -- 源系统代码
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 出生日期
    ,nvl(n.nationty_cd, o.nationty_cd) as nationty_cd -- 民族代码
    ,nvl(n.nati_place, o.nati_place) as nati_place -- 籍贯
    ,nvl(n.politic_status_cd, o.politic_status_cd) as politic_status_cd -- 政治面貌代码
    ,nvl(n.marriage_situ_cd, o.marriage_situ_cd) as marriage_situ_cd -- 婚姻状况代码
    ,nvl(n.emply_flg, o.emply_flg) as emply_flg -- 行员标志
    ,nvl(n.age, o.age) as age -- 年龄
    ,nvl(n.resdnt_flg, o.resdnt_flg) as resdnt_flg -- 居民标志
    ,nvl(n.nation_cd, o.nation_cd) as nation_cd -- 国籍代码
    ,nvl(n.dist_cd, o.dist_cd) as dist_cd -- 行政区域代码
    ,nvl(n.hxb_shard_flg, o.hxb_shard_flg) as hxb_shard_flg -- 我行股东标志
    ,nvl(n.owner_type_cd, o.owner_type_cd) as owner_type_cd -- 客户性质代码
    ,nvl(n.ctysd_rpr_flg, o.ctysd_rpr_flg) as ctysd_rpr_flg -- 农村户口标志
    ,nvl(n.hxb_rela_party_flg, o.hxb_rela_party_flg) as hxb_rela_party_flg -- 我行关联方标志
    ,nvl(n.hxb_trast_inter_bus_flg, o.hxb_trast_inter_bus_flg) as hxb_trast_inter_bus_flg -- 在我行办理过中间业务标志
    ,nvl(n.hxb_payoff_sal_acct_flg, o.hxb_payoff_sal_acct_flg) as hxb_payoff_sal_acct_flg -- 我行代发工资户标志
    ,nvl(n.hxb_reg_cust_flg, o.hxb_reg_cust_flg) as hxb_reg_cust_flg -- 我行定期客户标志
    ,nvl(n.hxb_finc_cust_flg, o.hxb_finc_cust_flg) as hxb_finc_cust_flg -- 我行理财客户标志
    ,nvl(n.hxb_vip_cust_idf, o.hxb_vip_cust_idf) as hxb_vip_cust_idf -- 我行VIP客户标识
    ,nvl(n.spouse_child_img_flg, o.spouse_child_img_flg) as spouse_child_img_flg -- 配偶及子女移民标志
    ,nvl(n.enjoy_cty_prefr_policy_flg, o.enjoy_cty_prefr_policy_flg) as enjoy_cty_prefr_policy_flg -- 享受国家优惠政策标志
    ,nvl(n.grad_sch, o.grad_sch) as grad_sch -- 毕业学校
    ,nvl(n.grad_year, o.grad_year) as grad_year -- 毕业年份
    ,nvl(n.e_mail, o.e_mail) as e_mail -- 电子邮箱
    ,nvl(n.open_acct_teller_id, o.open_acct_teller_id) as open_acct_teller_id -- 开户柜员编号
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.cust_id is null
                and o.lp_id is null
                and o.sorc_sys_cd is null
            ) or (
                o.gender_cd <> n.gender_cd
                or o.birth_dt <> n.birth_dt
                or o.nationty_cd <> n.nationty_cd
                or o.nati_place <> n.nati_place
                or o.politic_status_cd <> n.politic_status_cd
                or o.marriage_situ_cd <> n.marriage_situ_cd
                or o.emply_flg <> n.emply_flg
                or o.age <> n.age
                or o.resdnt_flg <> n.resdnt_flg
                or o.nation_cd <> n.nation_cd
                or o.dist_cd <> n.dist_cd
                or o.hxb_shard_flg <> n.hxb_shard_flg
                or o.owner_type_cd <> n.owner_type_cd
                or o.ctysd_rpr_flg <> n.ctysd_rpr_flg
                or o.hxb_rela_party_flg <> n.hxb_rela_party_flg
                or o.hxb_trast_inter_bus_flg <> n.hxb_trast_inter_bus_flg
                or o.hxb_payoff_sal_acct_flg <> n.hxb_payoff_sal_acct_flg
                or o.hxb_reg_cust_flg <> n.hxb_reg_cust_flg
                or o.hxb_finc_cust_flg <> n.hxb_finc_cust_flg
                or o.hxb_vip_cust_idf <> n.hxb_vip_cust_idf
                or o.spouse_child_img_flg <> n.spouse_child_img_flg
                or o.enjoy_cty_prefr_policy_flg <> n.enjoy_cty_prefr_policy_flg
                or o.grad_sch <> n.grad_sch
                or o.grad_year <> n.grad_year
                or o.e_mail <> n.e_mail
                or o.open_acct_teller_id <> n.open_acct_teller_id
                or o.open_acct_org_id <> n.open_acct_org_id
                or o.open_acct_dt <> n.open_acct_dt
            ) or (
                 case when (
                           n.cust_id is null
                           and n.lp_id is null
                           and n.sorc_sys_cd is null
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
                n.cust_id is null
                and n.lp_id is null
                and n.sorc_sys_cd is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv_cust_ifmsf1_tm n
    full join ${iml_schema}.pty_indv_cust_ifmsf1_bk o
        on
            o.cust_id = n.cust_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_indv_cust truncate partition for ('ifmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_indv_cust exchange subpartition p_ifmsf1_${batch_date} with table ${iml_schema}.pty_indv_cust_ifmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_indv_cust drop subpartition p_ifmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_indv_cust to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_indv_cust_ifmsf1_tm purge;
drop table ${iml_schema}.pty_indv_cust_ifmsf1_ex purge;
drop table ${iml_schema}.pty_indv_cust_ifmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_indv_cust', partname => 'p_ifmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);