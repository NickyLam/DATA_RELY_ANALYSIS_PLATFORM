/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_insure_guar_mimsf1
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
drop table ${iml_schema}.ast_col_insure_guar_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_insure_guar_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_insure_guar add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_insure_guar modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_insure_guar_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_insure_guar partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_insure_guar_mimsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,guartor_type_cd -- 保证人类型代码
    ,guartor_id -- 保证人编号
    ,guartor_name -- 保证人名称
    ,guartor_cert_type_cd -- 保证人证件类型代码
    ,guartor_orgnz_cd -- 保证人组织机构代码
    ,guartor_nat_std_indus_cls_cd -- 保证人国标行业分类代码
    ,guartor_net_asset_amt -- 保证人净资产金额
    ,guartor_econ_compnt_cd -- 保证人经济成分代码
    ,guartor_guar_indep_cd -- 保证人担保独立性代码
    ,guartor_rgst_cd -- 保证人注册地代码
    ,guartor_rgst_ext_rating_cd -- 保证人注册地外部评级结果代码
    ,guartor_ext_rating_dt -- 保证人外部评级日期
    ,guartor_ext_rating_rest_cd -- 保证人外部评级结果代码
    ,guartor_intnal_rating_dt -- 保证人内部评级日期
    ,guartor_intnal_rating_rest_cd -- 保证人内部评级结果代码
    ,guar_aim_cd -- 保证目的代码
    ,guar_insure_policy_num -- 保证保险保单号码
    ,stage_guar_flg -- 阶段性担保标志
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,resdnt_flg -- 是否居民标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_insure_guar
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_insure_guar_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_insure_guar partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_guarinsurance-1
insert into ${iml_schema}.ast_col_insure_guar_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,guartor_type_cd -- 保证人类型代码
    ,guartor_id -- 保证人编号
    ,guartor_name -- 保证人名称
    ,guartor_cert_type_cd -- 保证人证件类型代码
    ,guartor_orgnz_cd -- 保证人组织机构代码
    ,guartor_nat_std_indus_cls_cd -- 保证人国标行业分类代码
    ,guartor_net_asset_amt -- 保证人净资产金额
    ,guartor_econ_compnt_cd -- 保证人经济成分代码
    ,guartor_guar_indep_cd -- 保证人担保独立性代码
    ,guartor_rgst_cd -- 保证人注册地代码
    ,guartor_rgst_ext_rating_cd -- 保证人注册地外部评级结果代码
    ,guartor_ext_rating_dt -- 保证人外部评级日期
    ,guartor_ext_rating_rest_cd -- 保证人外部评级结果代码
    ,guartor_intnal_rating_dt -- 保证人内部评级日期
    ,guartor_intnal_rating_rest_cd -- 保证人内部评级结果代码
    ,guar_aim_cd -- 保证目的代码
    ,guar_insure_policy_num -- 保证保险保单号码
    ,stage_guar_flg -- 阶段性担保标志
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,resdnt_flg -- 是否居民标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,nvl(trim(p1.VOUCHERTYPE),'00') -- 保证人类型代码
    ,NVL(TRIM(P2.CORECUSTID),NVL(P1.VOUCHERNO,' ')) -- 保证人编号
    ,P1.VOUCHERNAME -- 保证人名称
    ,nvl(trim(P1.CARDTYPE),'0000') -- 保证人证件类型代码
    ,P1.CARDNO -- 保证人组织机构代码
    ,NVL(TRIM(P1.INDUSTRY),'-') -- 保证人国标行业分类代码
    ,P1.NETASSET -- 保证人净资产金额
    ,nvl(trim(p1.ECONOMIC),'-') -- 保证人经济成分代码
    ,nvl(trim(p1.INDEPENDENCE),'-') -- 保证人担保独立性代码
    ,NVL(TRIM(P1.REGISTCOUNTRY),'XXX') -- 保证人注册地代码
    ,nvl(trim(p1.REGISTCOUNTRYRESULT),'-') -- 保证人注册地外部评级结果代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.OUTRATINGDATE) -- 保证人外部评级日期
    ,nvl(trim(p1.OUTRATINGRESULT),'-') -- 保证人外部评级结果代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.INRATINGDATE) -- 保证人内部评级日期
    ,nvl(trim(p1.INRATINGRESULT),'-') -- 保证人内部评级结果代码
    ,nvl(trim(p1.PURPOSE),'00') -- 保证目的代码
    ,P1.INSURANCENO -- 保证保险保单号码
    ,P1.ISSTAGE -- 阶段性担保标志
    ,P1.REMARK -- 其他说明
    ,NVL(TRIM(P1.TDCURRENCY),'-') -- 币种代码
    ,P1.ISRESIDENT -- 是否居民标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_guarinsurance' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_guarinsurance p1
    left join ${iol_schema}.mims_ci_custinfo p2 on P1.VOUCHERNO = P2.CUSTID
and P2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P2.end_dt > to_date('${batch_date}','yyyymmdd')

where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_insure_guar_mimsf1_tm 
  	                                group by 
  	                                        asset_id
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
insert /*+ append */ into ${iml_schema}.ast_col_insure_guar_mimsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,guartor_type_cd -- 保证人类型代码
    ,guartor_id -- 保证人编号
    ,guartor_name -- 保证人名称
    ,guartor_cert_type_cd -- 保证人证件类型代码
    ,guartor_orgnz_cd -- 保证人组织机构代码
    ,guartor_nat_std_indus_cls_cd -- 保证人国标行业分类代码
    ,guartor_net_asset_amt -- 保证人净资产金额
    ,guartor_econ_compnt_cd -- 保证人经济成分代码
    ,guartor_guar_indep_cd -- 保证人担保独立性代码
    ,guartor_rgst_cd -- 保证人注册地代码
    ,guartor_rgst_ext_rating_cd -- 保证人注册地外部评级结果代码
    ,guartor_ext_rating_dt -- 保证人外部评级日期
    ,guartor_ext_rating_rest_cd -- 保证人外部评级结果代码
    ,guartor_intnal_rating_dt -- 保证人内部评级日期
    ,guartor_intnal_rating_rest_cd -- 保证人内部评级结果代码
    ,guar_aim_cd -- 保证目的代码
    ,guar_insure_policy_num -- 保证保险保单号码
    ,stage_guar_flg -- 阶段性担保标志
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,resdnt_flg -- 是否居民标志
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
    ,nvl(n.guartor_type_cd, o.guartor_type_cd) as guartor_type_cd -- 保证人类型代码
    ,nvl(n.guartor_id, o.guartor_id) as guartor_id -- 保证人编号
    ,nvl(n.guartor_name, o.guartor_name) as guartor_name -- 保证人名称
    ,nvl(n.guartor_cert_type_cd, o.guartor_cert_type_cd) as guartor_cert_type_cd -- 保证人证件类型代码
    ,nvl(n.guartor_orgnz_cd, o.guartor_orgnz_cd) as guartor_orgnz_cd -- 保证人组织机构代码
    ,nvl(n.guartor_nat_std_indus_cls_cd, o.guartor_nat_std_indus_cls_cd) as guartor_nat_std_indus_cls_cd -- 保证人国标行业分类代码
    ,nvl(n.guartor_net_asset_amt, o.guartor_net_asset_amt) as guartor_net_asset_amt -- 保证人净资产金额
    ,nvl(n.guartor_econ_compnt_cd, o.guartor_econ_compnt_cd) as guartor_econ_compnt_cd -- 保证人经济成分代码
    ,nvl(n.guartor_guar_indep_cd, o.guartor_guar_indep_cd) as guartor_guar_indep_cd -- 保证人担保独立性代码
    ,nvl(n.guartor_rgst_cd, o.guartor_rgst_cd) as guartor_rgst_cd -- 保证人注册地代码
    ,nvl(n.guartor_rgst_ext_rating_cd, o.guartor_rgst_ext_rating_cd) as guartor_rgst_ext_rating_cd -- 保证人注册地外部评级结果代码
    ,nvl(n.guartor_ext_rating_dt, o.guartor_ext_rating_dt) as guartor_ext_rating_dt -- 保证人外部评级日期
    ,nvl(n.guartor_ext_rating_rest_cd, o.guartor_ext_rating_rest_cd) as guartor_ext_rating_rest_cd -- 保证人外部评级结果代码
    ,nvl(n.guartor_intnal_rating_dt, o.guartor_intnal_rating_dt) as guartor_intnal_rating_dt -- 保证人内部评级日期
    ,nvl(n.guartor_intnal_rating_rest_cd, o.guartor_intnal_rating_rest_cd) as guartor_intnal_rating_rest_cd -- 保证人内部评级结果代码
    ,nvl(n.guar_aim_cd, o.guar_aim_cd) as guar_aim_cd -- 保证目的代码
    ,nvl(n.guar_insure_policy_num, o.guar_insure_policy_num) as guar_insure_policy_num -- 保证保险保单号码
    ,nvl(n.stage_guar_flg, o.stage_guar_flg) as stage_guar_flg -- 阶段性担保标志
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.resdnt_flg, o.resdnt_flg) as resdnt_flg -- 是否居民标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.guartor_type_cd <> n.guartor_type_cd
                or o.guartor_id <> n.guartor_id
                or o.guartor_name <> n.guartor_name
                or o.guartor_cert_type_cd <> n.guartor_cert_type_cd
                or o.guartor_orgnz_cd <> n.guartor_orgnz_cd
                or o.guartor_nat_std_indus_cls_cd <> n.guartor_nat_std_indus_cls_cd
                or o.guartor_net_asset_amt <> n.guartor_net_asset_amt
                or o.guartor_econ_compnt_cd <> n.guartor_econ_compnt_cd
                or o.guartor_guar_indep_cd <> n.guartor_guar_indep_cd
                or o.guartor_rgst_cd <> n.guartor_rgst_cd
                or o.guartor_rgst_ext_rating_cd <> n.guartor_rgst_ext_rating_cd
                or o.guartor_ext_rating_dt <> n.guartor_ext_rating_dt
                or o.guartor_ext_rating_rest_cd <> n.guartor_ext_rating_rest_cd
                or o.guartor_intnal_rating_dt <> n.guartor_intnal_rating_dt
                or o.guartor_intnal_rating_rest_cd <> n.guartor_intnal_rating_rest_cd
                or o.guar_aim_cd <> n.guar_aim_cd
                or o.guar_insure_policy_num <> n.guar_insure_policy_num
                or o.stage_guar_flg <> n.stage_guar_flg
                or o.other_comnt <> n.other_comnt
                or o.curr_cd <> n.curr_cd
                or o.resdnt_flg <> n.resdnt_flg
            ) or (
                 case when (
                           n.asset_id is null
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
                n.asset_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_insure_guar_mimsf1_tm n
    full join ${iml_schema}.ast_col_insure_guar_mimsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_insure_guar truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_insure_guar exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_insure_guar_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_insure_guar drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_insure_guar to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_insure_guar_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_insure_guar_mimsf1_ex purge;
drop table ${iml_schema}.ast_col_insure_guar_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_insure_guar', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);