/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_wat_info_icmsf1
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
drop table ${iml_schema}.ast_col_wat_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_wat_info_icmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_wat_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_wat_info modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_wat_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_wat_info partition for ('icmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_wat_info_icmsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,wat_id -- 权证编号
    ,wat_num -- 权证号码
    ,wat_name -- 权证名称
    ,wat_type_cd -- 权证类型代码
    ,licen_issue_autho_name -- 发证机关名称
    ,issue_dt -- 发证日期
    ,valid_closing_dt -- 有效截止日期
    ,rgst_dt -- 登记日期
    ,rgst_start_dt -- 登记生效日期
    ,rgst_end_dt -- 登记失效日期
    ,rgst_emply_id -- 登记员工编号
    ,insto_flow_id -- 入库流程编号
    ,acss_cont_id -- 从合同编号
    ,pri_contr_id -- 主合同编号
    ,insto_id -- 入库编号
    ,insto_dt -- 入库日期
    ,ex_flow_id -- 出库流程编号
    ,ex_dt -- 出库日期
    ,latest_debit_flow_id -- 最新借用流程编号
    ,latest_debit_dt -- 最新借用日期
    ,rn_flow_id -- 续借流程编号
    ,rn_dt -- 续借日期
    ,rn_cnt -- 续借次数
    ,latest_rtn_dt -- 最新归还日期
    ,wat_status_cd -- 权证状态类型代码
    ,uniq_wat_flg -- 唯一权证标志
    ,flow_status_cd -- 流程状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_wat_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_wat_info_icmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_wat_info partition for ('icmsf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_clr_rightcert_info-
insert into ${iml_schema}.ast_col_wat_info_icmsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,wat_id -- 权证编号
    ,wat_num -- 权证号码
    ,wat_name -- 权证名称
    ,wat_type_cd -- 权证类型代码
    ,licen_issue_autho_name -- 发证机关名称
    ,issue_dt -- 发证日期
    ,valid_closing_dt -- 有效截止日期
    ,rgst_dt -- 登记日期
    ,rgst_start_dt -- 登记生效日期
    ,rgst_end_dt -- 登记失效日期
    ,rgst_emply_id -- 登记员工编号
    ,insto_flow_id -- 入库流程编号
    ,acss_cont_id -- 从合同编号
    ,pri_contr_id -- 主合同编号
    ,insto_id -- 入库编号
    ,insto_dt -- 入库日期
    ,ex_flow_id -- 出库流程编号
    ,ex_dt -- 出库日期
    ,latest_debit_flow_id -- 最新借用流程编号
    ,latest_debit_dt -- 最新借用日期
    ,rn_flow_id -- 续借流程编号
    ,rn_dt -- 续借日期
    ,rn_cnt -- 续借次数
    ,latest_rtn_dt -- 最新归还日期
    ,wat_status_cd -- 权证状态类型代码
    ,uniq_wat_flg -- 唯一权证标志
    ,flow_status_cd -- 流程状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CLRID -- 资产编号
    ,'9999' -- 法人编号
    ,P1.RIGHTCERTID -- 权证编号
    ,P1.RIGHTCERTNO -- 权证号码
    ,P1.RIGHTCERTNAME -- 权证名称
    ,P1.RIGHTCERTTYPE -- 权证类型代码
    ,P1.RIGHTREGISTRATIONORG -- 发证机关名称
    ,P1.RIGHTREGISTRATIONDATE -- 发证日期
    ,P1.RIGHTDUEDATE -- 有效截止日期
    ,P1.INPUTDATE-- 登记日期
    ,P1.CLROWNERSTARTDATE -- 登记生效日期
    ,P1.CLROWNERENDDATE -- 登记失效日期
    ,P1.INPUTUSERID -- 登记员工编号
    ,' ' -- 入库流程编号
    ,' ' -- 从合同编号
    ,' ' -- 主合同编号
    ,' ' -- 入库编号
    ,P1.INWAREHOUSINGDATE -- 入库日期
    ,' ' -- 出库流程编号
    ,P1.OUTWAREHOUSINGDATE -- 出库日期
    ,' ' -- 最新借用流程编号
    ,P1.LASTOUTWHDATE -- 最新借用日期
    ,' ' -- 续借流程编号
    ,${iml_schema}.dateformat_max(null) -- 续借日期
    ,0 -- 续借次数
    ,P1.EXPCRETURNDATE -- 最新归还日期
    ,nvl(trim(P1.RIGHTCERTSTATUS),'00') -- 权证状态类型代码
    ,'-' -- 唯一权证标志
    ,'-' -- 流程状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_clr_rightcert_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_clr_rightcert_info p1
inner join (select t.*
                      ,row_number() over(partition by rightcertid order by clrid desc) rn 
                  from ${iol_schema}.icms_clr_rightcert_relative t 
                 where t.start_dt <= to_date('${batch_date}','yyyymmdd') 
                    and t.end_dt > to_date('${batch_date}','yyyymmdd')
                    and trim(t.clrid) is not null)p2 
on p1.rightcertid =p2.rightcertid
and p2.rn=1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_wat_info_icmsf1_tm 
  	                                group by 
  	                                        asset_id
  	                                        ,lp_id
  	                                        ,wat_id
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
insert /*+ append */ into ${iml_schema}.ast_col_wat_info_icmsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,wat_id -- 权证编号
    ,wat_num -- 权证号码
    ,wat_name -- 权证名称
    ,wat_type_cd -- 权证类型代码
    ,licen_issue_autho_name -- 发证机关名称
    ,issue_dt -- 发证日期
    ,valid_closing_dt -- 有效截止日期
    ,rgst_dt -- 登记日期
    ,rgst_start_dt -- 登记生效日期
    ,rgst_end_dt -- 登记失效日期
    ,rgst_emply_id -- 登记员工编号
    ,insto_flow_id -- 入库流程编号
    ,acss_cont_id -- 从合同编号
    ,pri_contr_id -- 主合同编号
    ,insto_id -- 入库编号
    ,insto_dt -- 入库日期
    ,ex_flow_id -- 出库流程编号
    ,ex_dt -- 出库日期
    ,latest_debit_flow_id -- 最新借用流程编号
    ,latest_debit_dt -- 最新借用日期
    ,rn_flow_id -- 续借流程编号
    ,rn_dt -- 续借日期
    ,rn_cnt -- 续借次数
    ,latest_rtn_dt -- 最新归还日期
    ,wat_status_cd -- 权证状态类型代码
    ,uniq_wat_flg -- 唯一权证标志
    ,flow_status_cd -- 流程状态代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.wat_id, o.wat_id) as wat_id -- 权证编号
    ,nvl(n.wat_num, o.wat_num) as wat_num -- 权证号码
    ,nvl(n.wat_name, o.wat_name) as wat_name -- 权证名称
    ,nvl(n.wat_type_cd, o.wat_type_cd) as wat_type_cd -- 权证类型代码
    ,nvl(n.licen_issue_autho_name, o.licen_issue_autho_name) as licen_issue_autho_name -- 发证机关名称
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 发证日期
    ,nvl(n.valid_closing_dt, o.valid_closing_dt) as valid_closing_dt -- 有效截止日期
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_start_dt, o.rgst_start_dt) as rgst_start_dt -- 登记生效日期
    ,nvl(n.rgst_end_dt, o.rgst_end_dt) as rgst_end_dt -- 登记失效日期
    ,nvl(n.rgst_emply_id, o.rgst_emply_id) as rgst_emply_id -- 登记员工编号
    ,nvl(n.insto_flow_id, o.insto_flow_id) as insto_flow_id -- 入库流程编号
    ,nvl(n.acss_cont_id, o.acss_cont_id) as acss_cont_id -- 从合同编号
    ,nvl(n.pri_contr_id, o.pri_contr_id) as pri_contr_id -- 主合同编号
    ,nvl(n.insto_id, o.insto_id) as insto_id -- 入库编号
    ,nvl(n.insto_dt, o.insto_dt) as insto_dt -- 入库日期
    ,nvl(n.ex_flow_id, o.ex_flow_id) as ex_flow_id -- 出库流程编号
    ,nvl(n.ex_dt, o.ex_dt) as ex_dt -- 出库日期
    ,nvl(n.latest_debit_flow_id, o.latest_debit_flow_id) as latest_debit_flow_id -- 最新借用流程编号
    ,nvl(n.latest_debit_dt, o.latest_debit_dt) as latest_debit_dt -- 最新借用日期
    ,nvl(n.rn_flow_id, o.rn_flow_id) as rn_flow_id -- 续借流程编号
    ,nvl(n.rn_dt, o.rn_dt) as rn_dt -- 续借日期
    ,nvl(n.rn_cnt, o.rn_cnt) as rn_cnt -- 续借次数
    ,nvl(n.latest_rtn_dt, o.latest_rtn_dt) as latest_rtn_dt -- 最新归还日期
    ,nvl(n.wat_status_cd, o.wat_status_cd) as wat_status_cd -- 权证状态类型代码
    ,nvl(n.uniq_wat_flg, o.uniq_wat_flg) as uniq_wat_flg -- 唯一权证标志
    ,nvl(n.flow_status_cd, o.flow_status_cd) as flow_status_cd -- 流程状态代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
                and o.wat_id is null
            ) or (
                o.wat_num <> n.wat_num
                or o.wat_name <> n.wat_name
                or o.wat_type_cd <> n.wat_type_cd
                or o.licen_issue_autho_name <> n.licen_issue_autho_name
                or o.issue_dt <> n.issue_dt
                or o.valid_closing_dt <> n.valid_closing_dt
                or o.rgst_dt <> n.rgst_dt
                or o.rgst_start_dt <> n.rgst_start_dt
                or o.rgst_end_dt <> n.rgst_end_dt
                or o.rgst_emply_id <> n.rgst_emply_id
                or o.insto_flow_id <> n.insto_flow_id
                or o.acss_cont_id <> n.acss_cont_id
                or o.pri_contr_id <> n.pri_contr_id
                or o.insto_id <> n.insto_id
                or o.insto_dt <> n.insto_dt
                or o.ex_flow_id <> n.ex_flow_id
                or o.ex_dt <> n.ex_dt
                or o.latest_debit_flow_id <> n.latest_debit_flow_id
                or o.latest_debit_dt <> n.latest_debit_dt
                or o.rn_flow_id <> n.rn_flow_id
                or o.rn_dt <> n.rn_dt
                or o.rn_cnt <> n.rn_cnt
                or o.latest_rtn_dt <> n.latest_rtn_dt
                or o.wat_status_cd <> n.wat_status_cd
                or o.uniq_wat_flg <> n.uniq_wat_flg
                or o.flow_status_cd <> n.flow_status_cd
            ) or (
                 case when (
                           n.asset_id is null
                           and n.lp_id is null
                           and n.wat_id is null
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
                n.asset_id is null
                and n.lp_id is null
                and n.wat_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_wat_info_icmsf1_tm n
    full join ${iml_schema}.ast_col_wat_info_icmsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.wat_id = n.wat_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_wat_info truncate partition for ('icmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_wat_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ast_col_wat_info_icmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_wat_info drop subpartition p_icmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_wat_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_wat_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_wat_info_icmsf1_ex purge;
drop table ${iml_schema}.ast_col_wat_info_icmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_wat_info', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);