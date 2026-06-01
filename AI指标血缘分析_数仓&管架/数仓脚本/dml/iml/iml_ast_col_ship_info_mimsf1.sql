/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_ship_info_mimsf1
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
drop table ${iml_schema}.ast_col_ship_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_ship_info_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_ship_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_ship_info modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_ship_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_ship_info partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_ship_info_mimsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,ship_idtfy_num -- 船舶识别号
    ,exchg_inpwn_rgst_id -- 交易所质押登记编号
    ,marine_cert_id -- 航运证编号
    ,engine_id -- 发动机编号
    ,lics_plat_num -- 牌照号码
    ,house_used_flg -- 一手二手标志
    ,local_cty_cd -- 所在国家代码
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,brand_prod_manuf -- 品牌生产厂商
    ,model_spec -- 型号规格
    ,ship_type_cd -- 船舶类型代码
    ,full_load_tonnage -- 满载排水量
    ,net_load_tonnage -- 净载排水量
    ,leave_factory_dt -- 出厂日期
    ,design_use_exp_dt -- 设计使用到期日期
    ,inv_id -- 发票编号
    ,inv_dt -- 发票日期
    ,inv_amt -- 发票金额
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_ship_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_ship_info_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_ship_info partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_ship-
insert into ${iml_schema}.ast_col_ship_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,ship_idtfy_num -- 船舶识别号
    ,exchg_inpwn_rgst_id -- 交易所质押登记编号
    ,marine_cert_id -- 航运证编号
    ,engine_id -- 发动机编号
    ,lics_plat_num -- 牌照号码
    ,house_used_flg -- 一手二手标志
    ,local_cty_cd -- 所在国家代码
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,brand_prod_manuf -- 品牌生产厂商
    ,model_spec -- 型号规格
    ,ship_type_cd -- 船舶类型代码
    ,full_load_tonnage -- 满载排水量
    ,net_load_tonnage -- 净载排水量
    ,leave_factory_dt -- 出厂日期
    ,design_use_exp_dt -- 设计使用到期日期
    ,inv_id -- 发票编号
    ,inv_dt -- 发票日期
    ,inv_amt -- 发票金额
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.IDENTYNO -- 船舶识别号
    ,P1.REGISTNO -- 交易所质押登记编号
    ,P1.SHIPCERNO -- 航运证编号
    ,P1.ENGINENO -- 发动机编号
    ,P1.PLATENO -- 牌照号码
    ,P1.ISNEWHOUSE -- 一手二手标志
    ,P1.COUNTRY -- 所在国家代码
    ,P1.PROVINCE -- 所在省代码
    ,P1.CITY -- 所在市代码
    ,P1.EQUIPMENTBRAND -- 品牌生产厂商
    ,P1.SPECIFICATIONNO -- 型号规格
    ,P1.SHIPTYPE -- 船舶类型代码
    ,P1.FULLCAPACITY -- 满载排水量
    ,P1.NETCAPACITY -- 净载排水量
    ,${iml_schema}.DATEFORMAT_MIN(P1.STARTDATE) -- 出厂日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.ENDDATE) -- 设计使用到期日期
    ,P1.INVOICENO -- 发票编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.INVOICEDATE) -- 发票日期
    ,P1.INVOICEMONEY -- 发票金额
    ,P1.REMARK -- 其他说明
    ,nvl(P1.TDCURRENCY,'-') -- 币种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_ship' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_ship p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_ship_info_mimsf1_tm 
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
insert /*+ append */ into ${iml_schema}.ast_col_ship_info_mimsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,ship_idtfy_num -- 船舶识别号
    ,exchg_inpwn_rgst_id -- 交易所质押登记编号
    ,marine_cert_id -- 航运证编号
    ,engine_id -- 发动机编号
    ,lics_plat_num -- 牌照号码
    ,house_used_flg -- 一手二手标志
    ,local_cty_cd -- 所在国家代码
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,brand_prod_manuf -- 品牌生产厂商
    ,model_spec -- 型号规格
    ,ship_type_cd -- 船舶类型代码
    ,full_load_tonnage -- 满载排水量
    ,net_load_tonnage -- 净载排水量
    ,leave_factory_dt -- 出厂日期
    ,design_use_exp_dt -- 设计使用到期日期
    ,inv_id -- 发票编号
    ,inv_dt -- 发票日期
    ,inv_amt -- 发票金额
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
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
    ,nvl(n.ship_idtfy_num, o.ship_idtfy_num) as ship_idtfy_num -- 船舶识别号
    ,nvl(n.exchg_inpwn_rgst_id, o.exchg_inpwn_rgst_id) as exchg_inpwn_rgst_id -- 交易所质押登记编号
    ,nvl(n.marine_cert_id, o.marine_cert_id) as marine_cert_id -- 航运证编号
    ,nvl(n.engine_id, o.engine_id) as engine_id -- 发动机编号
    ,nvl(n.lics_plat_num, o.lics_plat_num) as lics_plat_num -- 牌照号码
    ,nvl(n.house_used_flg, o.house_used_flg) as house_used_flg -- 一手二手标志
    ,nvl(n.local_cty_cd, o.local_cty_cd) as local_cty_cd -- 所在国家代码
    ,nvl(n.local_prov_cd, o.local_prov_cd) as local_prov_cd -- 所在省代码
    ,nvl(n.local_city_cd, o.local_city_cd) as local_city_cd -- 所在市代码
    ,nvl(n.brand_prod_manuf, o.brand_prod_manuf) as brand_prod_manuf -- 品牌生产厂商
    ,nvl(n.model_spec, o.model_spec) as model_spec -- 型号规格
    ,nvl(n.ship_type_cd, o.ship_type_cd) as ship_type_cd -- 船舶类型代码
    ,nvl(n.full_load_tonnage, o.full_load_tonnage) as full_load_tonnage -- 满载排水量
    ,nvl(n.net_load_tonnage, o.net_load_tonnage) as net_load_tonnage -- 净载排水量
    ,nvl(n.leave_factory_dt, o.leave_factory_dt) as leave_factory_dt -- 出厂日期
    ,nvl(n.design_use_exp_dt, o.design_use_exp_dt) as design_use_exp_dt -- 设计使用到期日期
    ,nvl(n.inv_id, o.inv_id) as inv_id -- 发票编号
    ,nvl(n.inv_dt, o.inv_dt) as inv_dt -- 发票日期
    ,nvl(n.inv_amt, o.inv_amt) as inv_amt -- 发票金额
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.ship_idtfy_num <> n.ship_idtfy_num
                or o.exchg_inpwn_rgst_id <> n.exchg_inpwn_rgst_id
                or o.marine_cert_id <> n.marine_cert_id
                or o.engine_id <> n.engine_id
                or o.lics_plat_num <> n.lics_plat_num
                or o.house_used_flg <> n.house_used_flg
                or o.local_cty_cd <> n.local_cty_cd
                or o.local_prov_cd <> n.local_prov_cd
                or o.local_city_cd <> n.local_city_cd
                or o.brand_prod_manuf <> n.brand_prod_manuf
                or o.model_spec <> n.model_spec
                or o.ship_type_cd <> n.ship_type_cd
                or o.full_load_tonnage <> n.full_load_tonnage
                or o.net_load_tonnage <> n.net_load_tonnage
                or o.leave_factory_dt <> n.leave_factory_dt
                or o.design_use_exp_dt <> n.design_use_exp_dt
                or o.inv_id <> n.inv_id
                or o.inv_dt <> n.inv_dt
                or o.inv_amt <> n.inv_amt
                or o.other_comnt <> n.other_comnt
                or o.curr_cd <> n.curr_cd
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
from ${iml_schema}.ast_col_ship_info_mimsf1_tm n
    full join ${iml_schema}.ast_col_ship_info_mimsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_ship_info truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_ship_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_ship_info_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_ship_info drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_ship_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_ship_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_ship_info_mimsf1_ex purge;
drop table ${iml_schema}.ast_col_ship_info_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_ship_info', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);