/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_col_wat_mgmt_prdure_info_mimsf1
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
drop table ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_tm purge;
drop table ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_col_wat_mgmt_prdure_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_col_wat_mgmt_prdure_info modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_col_wat_mgmt_prdure_info partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_type_cd -- 业务类型代码
    ,wat_temp_borwer_name -- 权证临时借用人名称
    ,wat_temp_ex_renew_rs_cd -- 权证临时出库续期原因代码
    ,wat_temp_ex_renew_spec_rs -- 权证临时出库续期具体原因
    ,wat_expect_rtn_dt -- 权证预计归还日期
    ,operr_id -- 经办人编号
    ,belong_org_id -- 所属机构编号
    ,oper_dt -- 经办日期
    ,wat_info_happ_chg_flg -- 权证信息是否发生变化标志
    ,wat_info_chg_situ_cd -- 权证信息变化情况代码
    ,wat_info_chg_situ_descb -- 权证信息变化情况描述
    ,new_right_vouch_id -- 新权利凭证编号
    ,wat_nomal_ex_rs_cd -- 权证正常出库原因代码
    ,wat_nomal_ex_spec_rs -- 权证正常出库具体原因
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_col_wat_mgmt_prdure_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_col_wat_mgmt_prdure_info partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_mulguarwarrantsprocess-
insert into ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_type_cd -- 业务类型代码
    ,wat_temp_borwer_name -- 权证临时借用人名称
    ,wat_temp_ex_renew_rs_cd -- 权证临时出库续期原因代码
    ,wat_temp_ex_renew_spec_rs -- 权证临时出库续期具体原因
    ,wat_expect_rtn_dt -- 权证预计归还日期
    ,operr_id -- 经办人编号
    ,belong_org_id -- 所属机构编号
    ,oper_dt -- 经办日期
    ,wat_info_happ_chg_flg -- 权证信息是否发生变化标志
    ,wat_info_chg_situ_cd -- 权证信息变化情况代码
    ,wat_info_chg_situ_descb -- 权证信息变化情况描述
    ,new_right_vouch_id -- 新权利凭证编号
    ,wat_nomal_ex_rs_cd -- 权证正常出库原因代码
    ,wat_nomal_ex_spec_rs -- 权证正常出库具体原因
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '231031'||P1.BUSINESSINSID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.BUSINESSINSID -- 业务编号
    ,NVL(TRIM(P1.TYPES),'-') -- 业务类型代码
    ,P1.PRINCIPAL -- 权证临时借用人名称
    ,NVL(TRIM(P1.BOWREASONTYPE),'-') -- 权证临时出库续期原因代码
    ,P1.BOWREASON -- 权证临时出库续期具体原因
    ,${iml_schema}.dateformat_min(P1.ACCBACKDATE) -- 权证预计归还日期
    ,P1.OPERTOR -- 经办人编号
    ,P1.DEPTCODE -- 所属机构编号
    ,${iml_schema}.dateformat_min(P1.OPERDATE) -- 经办日期
    ,P1.ISCHANGE -- 权证信息是否发生变化标志
    ,P1.CHANGETYPE -- 权证信息变化情况代码
    ,P1.CHANGEINFO -- 权证信息变化情况描述
    ,P1.NEWWARRANTSNO -- 新权利凭证编号
    ,NVL(TRIM(P1.OUTGOINGTYPE),'-') -- 权证正常出库原因代码
    ,P1.OUTGOINGREASON -- 权证正常出库具体原因
    ,P1.REAMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_mulguarwarrantsprocess' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_mulguarwarrantsprocess p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_type_cd -- 业务类型代码
    ,wat_temp_borwer_name -- 权证临时借用人名称
    ,wat_temp_ex_renew_rs_cd -- 权证临时出库续期原因代码
    ,wat_temp_ex_renew_spec_rs -- 权证临时出库续期具体原因
    ,wat_expect_rtn_dt -- 权证预计归还日期
    ,operr_id -- 经办人编号
    ,belong_org_id -- 所属机构编号
    ,oper_dt -- 经办日期
    ,wat_info_happ_chg_flg -- 权证信息是否发生变化标志
    ,wat_info_chg_situ_cd -- 权证信息变化情况代码
    ,wat_info_chg_situ_descb -- 权证信息变化情况描述
    ,new_right_vouch_id -- 新权利凭证编号
    ,wat_nomal_ex_rs_cd -- 权证正常出库原因代码
    ,wat_nomal_ex_spec_rs -- 权证正常出库具体原因
    ,remark -- 备注
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
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.wat_temp_borwer_name, o.wat_temp_borwer_name) as wat_temp_borwer_name -- 权证临时借用人名称
    ,nvl(n.wat_temp_ex_renew_rs_cd, o.wat_temp_ex_renew_rs_cd) as wat_temp_ex_renew_rs_cd -- 权证临时出库续期原因代码
    ,nvl(n.wat_temp_ex_renew_spec_rs, o.wat_temp_ex_renew_spec_rs) as wat_temp_ex_renew_spec_rs -- 权证临时出库续期具体原因
    ,nvl(n.wat_expect_rtn_dt, o.wat_expect_rtn_dt) as wat_expect_rtn_dt -- 权证预计归还日期
    ,nvl(n.operr_id, o.operr_id) as operr_id -- 经办人编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 经办日期
    ,nvl(n.wat_info_happ_chg_flg, o.wat_info_happ_chg_flg) as wat_info_happ_chg_flg -- 权证信息是否发生变化标志
    ,nvl(n.wat_info_chg_situ_cd, o.wat_info_chg_situ_cd) as wat_info_chg_situ_cd -- 权证信息变化情况代码
    ,nvl(n.wat_info_chg_situ_descb, o.wat_info_chg_situ_descb) as wat_info_chg_situ_descb -- 权证信息变化情况描述
    ,nvl(n.new_right_vouch_id, o.new_right_vouch_id) as new_right_vouch_id -- 新权利凭证编号
    ,nvl(n.wat_nomal_ex_rs_cd, o.wat_nomal_ex_rs_cd) as wat_nomal_ex_rs_cd -- 权证正常出库原因代码
    ,nvl(n.wat_nomal_ex_spec_rs, o.wat_nomal_ex_spec_rs) as wat_nomal_ex_spec_rs -- 权证正常出库具体原因
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.bus_id <> n.bus_id
                or o.bus_type_cd <> n.bus_type_cd
                or o.wat_temp_borwer_name <> n.wat_temp_borwer_name
                or o.wat_temp_ex_renew_rs_cd <> n.wat_temp_ex_renew_rs_cd
                or o.wat_temp_ex_renew_spec_rs <> n.wat_temp_ex_renew_spec_rs
                or o.wat_expect_rtn_dt <> n.wat_expect_rtn_dt
                or o.operr_id <> n.operr_id
                or o.belong_org_id <> n.belong_org_id
                or o.oper_dt <> n.oper_dt
                or o.wat_info_happ_chg_flg <> n.wat_info_happ_chg_flg
                or o.wat_info_chg_situ_cd <> n.wat_info_chg_situ_cd
                or o.wat_info_chg_situ_descb <> n.wat_info_chg_situ_descb
                or o.new_right_vouch_id <> n.new_right_vouch_id
                or o.wat_nomal_ex_rs_cd <> n.wat_nomal_ex_rs_cd
                or o.wat_nomal_ex_spec_rs <> n.wat_nomal_ex_spec_rs
                or o.remark <> n.remark
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
from ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_tm n
    full join ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_col_wat_mgmt_prdure_info truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_col_wat_mgmt_prdure_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_col_wat_mgmt_prdure_info drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_col_wat_mgmt_prdure_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_tm purge;
drop table ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_ex purge;
drop table ${iml_schema}.agt_col_wat_mgmt_prdure_info_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_col_wat_mgmt_prdure_info', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);