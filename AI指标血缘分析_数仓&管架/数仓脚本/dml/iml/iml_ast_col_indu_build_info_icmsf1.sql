/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_indu_build_info_icmsf1
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
drop table ${iml_schema}.ast_col_indu_build_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_indu_build_info_icmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_indu_build_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_indu_build_info modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_indu_build_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_indu_build_info partition for ('icmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_indu_build_info_icmsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,house_used_flg -- 一手二手标志
    ,two_in_one_flg -- 两证合一标志
    ,rel_esat_wat_id -- 不动产证号
    ,dev_mode_cd -- 开发模式代码
    ,all_mtg_flg -- 全部抵押标志
    ,bs_cont_id -- 买卖合同编号
    ,buy_dt -- 购房日期
    ,buy_amt -- 购房金额
    ,arch_area -- 建筑面积
    ,usbl_area -- 实用面积
    ,build_year -- 建成年份
    ,build_age -- 楼龄
    ,stru_type_cd -- 结构类型代码
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,street_name -- 街道名称
    ,dplat_num -- 门牌号码
    ,rel_esat_wat_rgst_addr -- 不动产权证登记地址
    ,floor_cnt -- 楼层数
    ,tot_floor_cnt -- 总楼层数
    ,status_cd -- 状态代码
    ,prop_tenor -- 产权期限
    ,land_use_right_id -- 土地证号
    ,land_char_cd -- 土地所有权性质代码
    ,land_get_way_cd -- 土地取得方式代码
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,land_use_right_exp_dt -- 土地使用权到期日期
    ,land_use_right_years -- 土地使用权年限
    ,land_usage_cd -- 土地用途代码
    ,other_prop_cert_flg -- 已有他项权证标志
    ,other_comnt -- 其他说明
    ,rent_flg -- 出租标志
    ,tentry_name -- 承租人名称
    ,rent_begin_dt -- 出租起始日期
    ,rent_exp_dt -- 出租到期日期
    ,rent_situ_comnt -- 出租情况说明
    ,curr_cd -- 币种代码
    ,rent_anl_inco -- 租赁年收入
    ,house_cmplt_flg -- 房屋竣工标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_indu_build_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_indu_build_info_icmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_indu_build_info partition for ('icmsf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_clr_asset_property_industryroom-
insert into ${iml_schema}.ast_col_indu_build_info_icmsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,house_used_flg -- 一手二手标志
    ,two_in_one_flg -- 两证合一标志
    ,rel_esat_wat_id -- 不动产证号
    ,dev_mode_cd -- 开发模式代码
    ,all_mtg_flg -- 全部抵押标志
    ,bs_cont_id -- 买卖合同编号
    ,buy_dt -- 购房日期
    ,buy_amt -- 购房金额
    ,arch_area -- 建筑面积
    ,usbl_area -- 实用面积
    ,build_year -- 建成年份
    ,build_age -- 楼龄
    ,stru_type_cd -- 结构类型代码
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,street_name -- 街道名称
    ,dplat_num -- 门牌号码
    ,rel_esat_wat_rgst_addr -- 不动产权证登记地址
    ,floor_cnt -- 楼层数
    ,tot_floor_cnt -- 总楼层数
    ,status_cd -- 状态代码
    ,prop_tenor -- 产权期限
    ,land_use_right_id -- 土地证号
    ,land_char_cd -- 土地所有权性质代码
    ,land_get_way_cd -- 土地取得方式代码
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,land_use_right_exp_dt -- 土地使用权到期日期
    ,land_use_right_years -- 土地使用权年限
    ,land_usage_cd -- 土地用途代码
    ,other_prop_cert_flg -- 已有他项权证标志
    ,other_comnt -- 其他说明
    ,rent_flg -- 出租标志
    ,tentry_name -- 承租人名称
    ,rent_begin_dt -- 出租起始日期
    ,rent_exp_dt -- 出租到期日期
    ,rent_situ_comnt -- 出租情况说明
    ,curr_cd -- 币种代码
    ,rent_anl_inco -- 租赁年收入
    ,house_cmplt_flg -- 房屋竣工标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CLRID -- 资产编号
    ,'9999' -- 法人编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.ISNEWHOUSE END -- 一手二手标志
    ,nvl(trim(P1.ISTWOTOGETHER),'-') -- 两证合一标志
    ,P1.WARRANTSNO -- 不动产证号
    ,nvl(trim(P1.DEVELOPMODE),'00') -- 开发模式代码
    ,nvl(trim(P1.ISTOTAL),'-') -- 全部抵押标志
    ,P1.CONTNO -- 买卖合同编号
    ,P1.TRADEDATE -- 购房日期
    ,P1.TRADEPRICE -- 购房金额
    ,P1.BUILDINGAREA -- 建筑面积
    ,P1.USEAREA -- 实用面积
    ,P1.CREATEYEAR -- 建成年份
    ,P1.BUILDAGE -- 楼龄
    ,nvl(trim(P1.ROOMSTRUCTE),'00') -- 结构类型代码
    ,nvl(trim(P1.PROVINCE),'000000') -- 所在省代码
    ,nvl(trim(P1.CITY),'000000') -- 所在市代码
    ,nvl(trim(P1.COUNTIES),'000000') -- 所在区代码
    ,P1.STREET -- 街道名称
    ,P1.ROOMNO -- 门牌号码
    ,P1.ADDRESS -- 不动产权证登记地址
    ,P1.STOREYNO -- 楼层数
    ,P1.TOTALSTOREYNO -- 总楼层数
    ,nvl(trim(P1.PRESENTSTATUS),'00') -- 状态代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.BUILDRIGHTINFO, '[0-9.]+')),0)) -- 产权期限
    ,P1.LANDNO -- 土地证号
    ,nvl(trim(P1.LANDUSENATURE),'00') -- 土地所有权性质代码
    ,nvl(trim(P1.LANDGAINWAY),'00') -- 土地取得方式代码
    ,P1.LANDSTARTDATE -- 土地使用权起始日期
    ,P1.LANDENDDATE -- 土地使用权到期日期
    ,P1.LANDUSERYEAR -- 土地使用权年限
    ,nvl(trim(P1.LANDUSERING),'00') -- 土地用途代码
    ,nvl(trim(P1.ISOTHERRIGHT),'-') -- 已有他项权证标志
    ,P1.REMARK -- 其他说明
    ,nvl(trim(P1.ISRENTS),'-') -- 出租标志
    ,P1.HPADDR -- 承租人名称
    ,P1.HIRESDATE -- 出租起始日期
    ,P1.HIREEDATE -- 出租到期日期
    ,P1.HIREREMARK -- 出租情况说明
    ,nvl(trim(P1.TDCURRENCY),'CNY') -- 币种代码
    ,p1.YEARLYRENTAL -- 租赁年收入
    ,nvl(trim(P1.iscompleted),'-') -- 房屋竣工标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_clr_asset_property_industryroom' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_clr_asset_property_industryroom p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ISNEWHOUSE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_CLR_ASSET_PROPERTY_INDUSTRYROOM'
        AND R1.SRC_FIELD_EN_NAME= 'ISNEWHOUSE'
        AND R1.TARGET_TAB_EN_NAME= 'AST_COL_INDU_BUILD_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'HOUSE_USED_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_indu_build_info_icmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.ast_col_indu_build_info_icmsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,house_used_flg -- 一手二手标志
    ,two_in_one_flg -- 两证合一标志
    ,rel_esat_wat_id -- 不动产证号
    ,dev_mode_cd -- 开发模式代码
    ,all_mtg_flg -- 全部抵押标志
    ,bs_cont_id -- 买卖合同编号
    ,buy_dt -- 购房日期
    ,buy_amt -- 购房金额
    ,arch_area -- 建筑面积
    ,usbl_area -- 实用面积
    ,build_year -- 建成年份
    ,build_age -- 楼龄
    ,stru_type_cd -- 结构类型代码
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,street_name -- 街道名称
    ,dplat_num -- 门牌号码
    ,rel_esat_wat_rgst_addr -- 不动产权证登记地址
    ,floor_cnt -- 楼层数
    ,tot_floor_cnt -- 总楼层数
    ,status_cd -- 状态代码
    ,prop_tenor -- 产权期限
    ,land_use_right_id -- 土地证号
    ,land_char_cd -- 土地所有权性质代码
    ,land_get_way_cd -- 土地取得方式代码
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,land_use_right_exp_dt -- 土地使用权到期日期
    ,land_use_right_years -- 土地使用权年限
    ,land_usage_cd -- 土地用途代码
    ,other_prop_cert_flg -- 已有他项权证标志
    ,other_comnt -- 其他说明
    ,rent_flg -- 出租标志
    ,tentry_name -- 承租人名称
    ,rent_begin_dt -- 出租起始日期
    ,rent_exp_dt -- 出租到期日期
    ,rent_situ_comnt -- 出租情况说明
    ,curr_cd -- 币种代码
    ,rent_anl_inco -- 租赁年收入
    ,house_cmplt_flg -- 房屋竣工标志
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
    ,nvl(n.house_used_flg, o.house_used_flg) as house_used_flg -- 一手二手标志
    ,nvl(n.two_in_one_flg, o.two_in_one_flg) as two_in_one_flg -- 两证合一标志
    ,nvl(n.rel_esat_wat_id, o.rel_esat_wat_id) as rel_esat_wat_id -- 不动产证号
    ,nvl(n.dev_mode_cd, o.dev_mode_cd) as dev_mode_cd -- 开发模式代码
    ,nvl(n.all_mtg_flg, o.all_mtg_flg) as all_mtg_flg -- 全部抵押标志
    ,nvl(n.bs_cont_id, o.bs_cont_id) as bs_cont_id -- 买卖合同编号
    ,nvl(n.buy_dt, o.buy_dt) as buy_dt -- 购房日期
    ,nvl(n.buy_amt, o.buy_amt) as buy_amt -- 购房金额
    ,nvl(n.arch_area, o.arch_area) as arch_area -- 建筑面积
    ,nvl(n.usbl_area, o.usbl_area) as usbl_area -- 实用面积
    ,nvl(n.build_year, o.build_year) as build_year -- 建成年份
    ,nvl(n.build_age, o.build_age) as build_age -- 楼龄
    ,nvl(n.stru_type_cd, o.stru_type_cd) as stru_type_cd -- 结构类型代码
    ,nvl(n.local_prov_cd, o.local_prov_cd) as local_prov_cd -- 所在省代码
    ,nvl(n.local_city_cd, o.local_city_cd) as local_city_cd -- 所在市代码
    ,nvl(n.local_rg_cd, o.local_rg_cd) as local_rg_cd -- 所在区代码
    ,nvl(n.street_name, o.street_name) as street_name -- 街道名称
    ,nvl(n.dplat_num, o.dplat_num) as dplat_num -- 门牌号码
    ,nvl(n.rel_esat_wat_rgst_addr, o.rel_esat_wat_rgst_addr) as rel_esat_wat_rgst_addr -- 不动产权证登记地址
    ,nvl(n.floor_cnt, o.floor_cnt) as floor_cnt -- 楼层数
    ,nvl(n.tot_floor_cnt, o.tot_floor_cnt) as tot_floor_cnt -- 总楼层数
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.prop_tenor, o.prop_tenor) as prop_tenor -- 产权期限
    ,nvl(n.land_use_right_id, o.land_use_right_id) as land_use_right_id -- 土地证号
    ,nvl(n.land_char_cd, o.land_char_cd) as land_char_cd -- 土地所有权性质代码
    ,nvl(n.land_get_way_cd, o.land_get_way_cd) as land_get_way_cd -- 土地取得方式代码
    ,nvl(n.land_use_right_begin_dt, o.land_use_right_begin_dt) as land_use_right_begin_dt -- 土地使用权起始日期
    ,nvl(n.land_use_right_exp_dt, o.land_use_right_exp_dt) as land_use_right_exp_dt -- 土地使用权到期日期
    ,nvl(n.land_use_right_years, o.land_use_right_years) as land_use_right_years -- 土地使用权年限
    ,nvl(n.land_usage_cd, o.land_usage_cd) as land_usage_cd -- 土地用途代码
    ,nvl(n.other_prop_cert_flg, o.other_prop_cert_flg) as other_prop_cert_flg -- 已有他项权证标志
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,nvl(n.rent_flg, o.rent_flg) as rent_flg -- 出租标志
    ,nvl(n.tentry_name, o.tentry_name) as tentry_name -- 承租人名称
    ,nvl(n.rent_begin_dt, o.rent_begin_dt) as rent_begin_dt -- 出租起始日期
    ,nvl(n.rent_exp_dt, o.rent_exp_dt) as rent_exp_dt -- 出租到期日期
    ,nvl(n.rent_situ_comnt, o.rent_situ_comnt) as rent_situ_comnt -- 出租情况说明
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.rent_anl_inco, o.rent_anl_inco) as rent_anl_inco -- 租赁年收入
    ,nvl(n.house_cmplt_flg, o.house_cmplt_flg) as house_cmplt_flg -- 房屋竣工标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.house_used_flg <> n.house_used_flg
                or o.two_in_one_flg <> n.two_in_one_flg
                or o.rel_esat_wat_id <> n.rel_esat_wat_id
                or o.dev_mode_cd <> n.dev_mode_cd
                or o.all_mtg_flg <> n.all_mtg_flg
                or o.bs_cont_id <> n.bs_cont_id
                or o.buy_dt <> n.buy_dt
                or o.buy_amt <> n.buy_amt
                or o.arch_area <> n.arch_area
                or o.usbl_area <> n.usbl_area
                or o.build_year <> n.build_year
                or o.build_age <> n.build_age
                or o.stru_type_cd <> n.stru_type_cd
                or o.local_prov_cd <> n.local_prov_cd
                or o.local_city_cd <> n.local_city_cd
                or o.local_rg_cd <> n.local_rg_cd
                or o.street_name <> n.street_name
                or o.dplat_num <> n.dplat_num
                or o.rel_esat_wat_rgst_addr <> n.rel_esat_wat_rgst_addr
                or o.floor_cnt <> n.floor_cnt
                or o.tot_floor_cnt <> n.tot_floor_cnt
                or o.status_cd <> n.status_cd
                or o.prop_tenor <> n.prop_tenor
                or o.land_use_right_id <> n.land_use_right_id
                or o.land_char_cd <> n.land_char_cd
                or o.land_get_way_cd <> n.land_get_way_cd
                or o.land_use_right_begin_dt <> n.land_use_right_begin_dt
                or o.land_use_right_exp_dt <> n.land_use_right_exp_dt
                or o.land_use_right_years <> n.land_use_right_years
                or o.land_usage_cd <> n.land_usage_cd
                or o.other_prop_cert_flg <> n.other_prop_cert_flg
                or o.other_comnt <> n.other_comnt
                or o.rent_flg <> n.rent_flg
                or o.tentry_name <> n.tentry_name
                or o.rent_begin_dt <> n.rent_begin_dt
                or o.rent_exp_dt <> n.rent_exp_dt
                or o.rent_situ_comnt <> n.rent_situ_comnt
                or o.curr_cd <> n.curr_cd
                or o.rent_anl_inco <> n.rent_anl_inco
                or o.house_cmplt_flg <> n.house_cmplt_flg
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
from ${iml_schema}.ast_col_indu_build_info_icmsf1_tm n
    full join ${iml_schema}.ast_col_indu_build_info_icmsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_indu_build_info truncate partition for ('icmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_indu_build_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ast_col_indu_build_info_icmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_indu_build_info drop subpartition p_icmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_indu_build_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_indu_build_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_indu_build_info_icmsf1_ex purge;
drop table ${iml_schema}.ast_col_indu_build_info_icmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_indu_build_info', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);