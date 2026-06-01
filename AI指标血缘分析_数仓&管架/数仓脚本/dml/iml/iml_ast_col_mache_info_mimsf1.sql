/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_mache_info_mimsf1
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
drop table ${iml_schema}.ast_col_mache_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_mache_info_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_mache_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_mache_info modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_mache_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_mache_info partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_mache_info_mimsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,equip_id -- 设备铭牌编号
    ,house_used_flg -- 一手二手标志
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,equip_type_cd -- 设备类型代码
    ,equip_cls_cd -- 设备分类代码
    ,equip_model -- 设备型号
    ,prod_manuf -- 生产厂商
    ,leave_factory_dt -- 出厂日期
    ,use_exp_dt -- 使用到期日期
    ,prod_qual_cert_flg -- 有产品合格证标志
    ,inv_id -- 发票编号
    ,inv_dt -- 发票日期
    ,inv_amt -- 发票金额
    ,curr_cd -- 币种代码
    ,descb -- 描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_mache_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_mache_info_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_mache_info partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_equipment-1
insert into ${iml_schema}.ast_col_mache_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,equip_id -- 设备铭牌编号
    ,house_used_flg -- 一手二手标志
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,equip_type_cd -- 设备类型代码
    ,equip_cls_cd -- 设备分类代码
    ,equip_model -- 设备型号
    ,prod_manuf -- 生产厂商
    ,leave_factory_dt -- 出厂日期
    ,use_exp_dt -- 使用到期日期
    ,prod_qual_cert_flg -- 有产品合格证标志
    ,inv_id -- 发票编号
    ,inv_dt -- 发票日期
    ,inv_amt -- 发票金额
    ,curr_cd -- 币种代码
    ,descb -- 描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.EQUIPNO -- 设备铭牌编号
    ,nvl(trim(P1.ISNEWHOUSE),'00') -- 一手二手标志
    ,P1.PROVINCE -- 所在省代码
    ,P1.CITY -- 所在市代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.EQUIPTYPE END -- 设备类型代码
    ,nvl(trim(P1.EQUIPSORT),'-') -- 设备分类代码
    ,P1.SPECIFICATIONNO -- 设备型号
    ,P1.EQUIPMENTBRAND -- 生产厂商
    ,${iml_schema}.dateformat_min(P1.STARTDATE) -- 出厂日期
    ,${iml_schema}.dateformat_max(P1.ENDDATE) -- 使用到期日期
    ,nvl(trim(P1.ISQUALIFY),'-') -- 有产品合格证标志
    ,P1.INVOICENO -- 发票编号
    ,${iml_schema}.dateformat_min(P1.INVOICEDATE) -- 发票日期
    ,P1.INVOICEMONEY -- 发票金额
    ,nvl(trim(P1.TDCURRENCY),'-') -- 币种代码
    ,P1.REMARK -- 描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_equipment' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_equipment p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.EQUIPTYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MIMS'
        AND R1.SRC_TAB_EN_NAME= 'MIMS_SI_EQUIPMENT'
        AND R1.SRC_FIELD_EN_NAME= 'EQUIPTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AST_COL_MACHE_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'EQUIP_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_mache_info_mimsf1_tm 
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
insert /*+ append */ into ${iml_schema}.ast_col_mache_info_mimsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,equip_id -- 设备铭牌编号
    ,house_used_flg -- 一手二手标志
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,equip_type_cd -- 设备类型代码
    ,equip_cls_cd -- 设备分类代码
    ,equip_model -- 设备型号
    ,prod_manuf -- 生产厂商
    ,leave_factory_dt -- 出厂日期
    ,use_exp_dt -- 使用到期日期
    ,prod_qual_cert_flg -- 有产品合格证标志
    ,inv_id -- 发票编号
    ,inv_dt -- 发票日期
    ,inv_amt -- 发票金额
    ,curr_cd -- 币种代码
    ,descb -- 描述
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
    ,nvl(n.equip_id, o.equip_id) as equip_id -- 设备铭牌编号
    ,nvl(n.house_used_flg, o.house_used_flg) as house_used_flg -- 一手二手标志
    ,nvl(n.local_prov_cd, o.local_prov_cd) as local_prov_cd -- 所在省代码
    ,nvl(n.local_city_cd, o.local_city_cd) as local_city_cd -- 所在市代码
    ,nvl(n.equip_type_cd, o.equip_type_cd) as equip_type_cd -- 设备类型代码
    ,nvl(n.equip_cls_cd, o.equip_cls_cd) as equip_cls_cd -- 设备分类代码
    ,nvl(n.equip_model, o.equip_model) as equip_model -- 设备型号
    ,nvl(n.prod_manuf, o.prod_manuf) as prod_manuf -- 生产厂商
    ,nvl(n.leave_factory_dt, o.leave_factory_dt) as leave_factory_dt -- 出厂日期
    ,nvl(n.use_exp_dt, o.use_exp_dt) as use_exp_dt -- 使用到期日期
    ,nvl(n.prod_qual_cert_flg, o.prod_qual_cert_flg) as prod_qual_cert_flg -- 有产品合格证标志
    ,nvl(n.inv_id, o.inv_id) as inv_id -- 发票编号
    ,nvl(n.inv_dt, o.inv_dt) as inv_dt -- 发票日期
    ,nvl(n.inv_amt, o.inv_amt) as inv_amt -- 发票金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.descb, o.descb) as descb -- 描述
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.equip_id <> n.equip_id
                or o.house_used_flg <> n.house_used_flg
                or o.local_prov_cd <> n.local_prov_cd
                or o.local_city_cd <> n.local_city_cd
                or o.equip_type_cd <> n.equip_type_cd
                or o.equip_cls_cd <> n.equip_cls_cd
                or o.equip_model <> n.equip_model
                or o.prod_manuf <> n.prod_manuf
                or o.leave_factory_dt <> n.leave_factory_dt
                or o.use_exp_dt <> n.use_exp_dt
                or o.prod_qual_cert_flg <> n.prod_qual_cert_flg
                or o.inv_id <> n.inv_id
                or o.inv_dt <> n.inv_dt
                or o.inv_amt <> n.inv_amt
                or o.curr_cd <> n.curr_cd
                or o.descb <> n.descb
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
from ${iml_schema}.ast_col_mache_info_mimsf1_tm n
    full join ${iml_schema}.ast_col_mache_info_mimsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_mache_info truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_mache_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_mache_info_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_mache_info drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_mache_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_mache_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_mache_info_mimsf1_ex purge;
drop table ${iml_schema}.ast_col_mache_info_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_mache_info', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);