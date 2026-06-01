/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_fkd_estate_info_icmsf1
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
alter table ${iml_schema}.ast_fkd_estate_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_fkd_estate_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_fkd_estate_info partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_fkd_estate_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_fkd_estate_info_icmsf1_op purge;
drop table ${iml_schema}.ast_fkd_estate_info_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_fkd_estate_info_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    estate_list_id -- 房产列表编号
    ,asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,city_cd -- 城市代码
    ,city_name -- 城市名称
    ,rg_cd -- 区域代码
    ,rg_name -- 区域名称
    ,estat_id -- 楼盘编号
    ,comm_addr -- 小区地址
    ,estat_position -- 楼盘位置
    ,estate_type_cd -- 房产类型代码
    ,house_id -- 楼编号
    ,floor_num -- 楼层号
    ,unit_num -- 单元室号
    ,estate_fitmt_situ_cd -- 房产装修情况代码
    ,orient_cd -- 朝向代码
    ,estim_corp_name -- 评估机构名称
    ,onl_estim_val -- 线上评估价值
    ,estim_way_cd -- 评估方式代码
    ,formal_estim_val -- 正式评估价值
    ,house_area -- 房屋面积
    ,build_year -- 建成年份
    ,ths_tm_mtg_flg -- 本次抵押标志
    ,empty_flg -- 清房标志
    ,vacy_flg -- 空置标志
    ,rent_flg -- 出租标志
    ,rent_dt -- 出租日期
    ,get_house_dt -- 取房日期
    ,get_house_way_cd -- 取房方式代码
    ,prop_exp_dt -- 产权到期日期
    ,prop_co_ownr_rela_cd -- 产权共有人关系代码
    ,lh_obg_cd -- 上手权利人代码
    ,lh_mtg_amt -- 上手抵押金额
    ,land_char_cd -- 土地性质代码
    ,basm_flg -- 地下室标志
    ,arch_area -- 建筑面积
    ,land_up_area -- 地上面积
    ,land_next_area -- 地下面积
    ,resv_house_qtty -- 备用房数量
    ,resv_house_empty_flg -- 备用房清房标志
    ,resv_house_addr -- 备用房地址
    ,entry_dt -- 入抵日期
    ,relief_dt -- 解抵日期
    ,main_debit_ps_obg_flg -- 主借人权利人标志
    ,spouse_obg_flg -- 配偶权利人标志
    ,house_usage -- 房屋用途
    ,tot_floor_cnt -- 总楼层数
    ,house_num_id -- 房号编号
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,house_stru_type_descb -- 房屋结构类型描述
    ,merchd_house_char_cd -- 商品房性质代码
    ,evlbld_house_flg -- 电梯楼标志
    ,own_situ_comnt -- 共有情况说明
    ,bk_price -- 贝壳网房产评估价值
    ,tentry_name -- 承租人姓名
    ,rent_begin_dt -- 租赁起始日期
    ,rent_termnt_dt -- 租赁终止日期
    ,tentry_cert_type_cd -- 承租人证件类型代码
    ,tentry_cert_no -- 承租人证件号码
    ,mon_rent -- 月租金
    ,rent_coll_ped -- 租金收缴周期
    ,rela_ps_type_cd -- 关联人类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_fkd_estate_info partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.ast_fkd_estate_info_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_fkd_estate_info partition for ('icmsf1') where 0=1;

create table ${iml_schema}.ast_fkd_estate_info_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_fkd_estate_info partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_fkd_house_list-
insert into ${iml_schema}.ast_fkd_estate_info_icmsf1_tm(
    estate_list_id -- 房产列表编号
    ,asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,city_cd -- 城市代码
    ,city_name -- 城市名称
    ,rg_cd -- 区域代码
    ,rg_name -- 区域名称
    ,estat_id -- 楼盘编号
    ,comm_addr -- 小区地址
    ,estat_position -- 楼盘位置
    ,estate_type_cd -- 房产类型代码
    ,house_id -- 楼编号
    ,floor_num -- 楼层号
    ,unit_num -- 单元室号
    ,estate_fitmt_situ_cd -- 房产装修情况代码
    ,orient_cd -- 朝向代码
    ,estim_corp_name -- 评估机构名称
    ,onl_estim_val -- 线上评估价值
    ,estim_way_cd -- 评估方式代码
    ,formal_estim_val -- 正式评估价值
    ,house_area -- 房屋面积
    ,build_year -- 建成年份
    ,ths_tm_mtg_flg -- 本次抵押标志
    ,empty_flg -- 清房标志
    ,vacy_flg -- 空置标志
    ,rent_flg -- 出租标志
    ,rent_dt -- 出租日期
    ,get_house_dt -- 取房日期
    ,get_house_way_cd -- 取房方式代码
    ,prop_exp_dt -- 产权到期日期
    ,prop_co_ownr_rela_cd -- 产权共有人关系代码
    ,lh_obg_cd -- 上手权利人代码
    ,lh_mtg_amt -- 上手抵押金额
    ,land_char_cd -- 土地性质代码
    ,basm_flg -- 地下室标志
    ,arch_area -- 建筑面积
    ,land_up_area -- 地上面积
    ,land_next_area -- 地下面积
    ,resv_house_qtty -- 备用房数量
    ,resv_house_empty_flg -- 备用房清房标志
    ,resv_house_addr -- 备用房地址
    ,entry_dt -- 入抵日期
    ,relief_dt -- 解抵日期
    ,main_debit_ps_obg_flg -- 主借人权利人标志
    ,spouse_obg_flg -- 配偶权利人标志
    ,house_usage -- 房屋用途
    ,tot_floor_cnt -- 总楼层数
    ,house_num_id -- 房号编号
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,house_stru_type_descb -- 房屋结构类型描述
    ,merchd_house_char_cd -- 商品房性质代码
    ,evlbld_house_flg -- 电梯楼标志
    ,own_situ_comnt -- 共有情况说明
    ,bk_price -- 贝壳网房产评估价值
    ,tentry_name -- 承租人姓名
    ,rent_begin_dt -- 租赁起始日期
    ,rent_termnt_dt -- 租赁终止日期
    ,tentry_cert_type_cd -- 承租人证件类型代码
    ,tentry_cert_no -- 承租人证件号码
    ,mon_rent -- 月租金
    ,rent_coll_ped -- 租金收缴周期
    ,rela_ps_type_cd -- 关联人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SERIALNO -- 房产列表编号
    ,'302001'||P1.SERIALNO -- 资产编号
    ,'9999' -- 法人编号
    ,P1.RELATIVESERIALNO -- 业务流水号
    ,P1.CITYAREACODE -- 城市代码
    ,P1.CITYNAME -- 城市名称
    ,nvl(trim(P1.AREACODE),'000000') -- 区域代码
    ,P1.AREANAME -- 区域名称
    ,P1.PROJECTID -- 楼盘编号
    ,P1.PROJECTNAME -- 小区地址
    ,P1.PROJECTADDR -- 楼盘位置
    ,NVL(TRIM(P1.PROPERTYTYPE),'0000000') -- 房产类型代码
    ,P1.BUILDINGCODE -- 楼编号
    ,P1.FLOORNO -- 楼层号
    ,P1.ROOMNO -- 单元室号
    ,NVL(TRIM(P1.HSDECORATESTATE),'0') -- 房产装修情况代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.FRONTCODE END -- 朝向代码
    ,P1.ASSESSMENTCOM -- 评估机构名称
    ,P1.LINEPRICE -- 线上评估价值
    ,nvl(trim(P1.ASSESSMENTTYPE),'00') -- 评估方式代码
    ,P1.FORMALPRICE -- 正式评估价值
    ,P1.ROOMSIZE -- 房屋面积
    ,TO_NUMBER(NVL(TRIM(P1.BUILDINGDATE),0)) -- 建成年份
    ,P1.PLEDGEIND -- 本次抵押标志
    ,P1.ISCLEARINGHOUSE -- 清房标志
    ,P1.ISVACANT -- 空置标志
    ,P1.ISLEASE -- 出租标志
    ,P1.LEASETIME -- 出租日期
    ,${iml_schema}.dateformat_min(P1.GETTIME) -- 取房日期
    ,NVL(TRIM(P1.GETMODE),'00') -- 取房方式代码
    ,P1.PROPERTYRIGHTDUEDATE -- 产权到期日期
    ,nvl(trim(P1.HSOBLIGEERELATIVE),'-')   -- 产权共有人关系代码
    ,P1.OBLIGEE -- 上手权利人代码
    ,P1.MORTGAGEAMT -- 上手抵押金额
    ,nvl(trim(P1.LANDCATEGORY),'000000') -- 土地性质代码
    ,P1.HSISBASEMENT -- 地下室标志
    ,P1.HSCOVEREDAREA -- 建筑面积
    ,P1.HSOVERGROUNDAREA -- 地上面积
    ,P1.HSBASEMENTAREA -- 地下面积
    ,TO_NUMBER(NVL(TRIM(P1.SPAREROOMCOUNT),0)) -- 备用房数量
    ,P1.SPAREROOMISCLEARINGHOUSE -- 备用房清房标志
    ,P1.SPAREROOMADDR -- 备用房地址
    ,P1.HSUPPERINMORTGAGEDATE -- 入抵日期
    ,P1.HSUPPEROUTMORTGAGEDATE -- 解抵日期
    ,P1.OBLIGEEIND -- 主借人权利人标志
    ,P1.PARTNEROBLIGEEIND -- 配偶权利人标志
    ,P1.HOUSEPURPOSE -- 房屋用途
    ,TO_NUMBER(NVL(TRIM(P1.TOTALFLOOR),0)) -- 总楼层数
    ,P1.HOUSEID -- 房号编号
    ,P1.TITLECERTIFICATEGETTIME -- 土地使用权起始日期
    ,P1.HOUSETYPE -- 房屋结构类型描述
    ,nvl(trim(P1.HOUSESTATUS),'-') -- 商品房性质代码
    ,nvl(trim(P1.ISEVLBLD),'-') -- 电梯楼标志
    ,P1.COOWNERSHIP -- 共有情况说明
    ,P1.BKPRICE -- 贝壳网房产评估价值
    ,P1.CUSNAMEHIRE -- 承租人姓名
    ,${iml_schema}.dateformat_min(P1.STARTDATEHIRE) -- 租赁起始日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATEHIRE) -- 租赁终止日期
    ,nvl(trim(P1.CERTTYPEHIRE),'0000') -- 承租人证件类型代码
    ,P1.CERTCODEHIRE -- 承租人证件号码
    ,P1.MOURENT -- 月租金
    ,P1.RENTCYCLE -- 租金收缴周期
    ,'-' -- 关联人类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_fkd_house_list' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_fkd_house_list p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.FRONTCODE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_FKD_HOUSE_LIST'
        AND R2.SRC_FIELD_EN_NAME= 'FRONTCODE'
        AND R2.TARGET_TAB_EN_NAME= 'AST_FKD_ESTATE_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ORIENT_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_fkd_estate_info_icmsf1_tm 
  	                                group by 
  	                                        estate_list_id
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
        into ${iml_schema}.ast_fkd_estate_info_icmsf1_cl(
            estate_list_id -- 房产列表编号
    ,asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,city_cd -- 城市代码
    ,city_name -- 城市名称
    ,rg_cd -- 区域代码
    ,rg_name -- 区域名称
    ,estat_id -- 楼盘编号
    ,comm_addr -- 小区地址
    ,estat_position -- 楼盘位置
    ,estate_type_cd -- 房产类型代码
    ,house_id -- 楼编号
    ,floor_num -- 楼层号
    ,unit_num -- 单元室号
    ,estate_fitmt_situ_cd -- 房产装修情况代码
    ,orient_cd -- 朝向代码
    ,estim_corp_name -- 评估机构名称
    ,onl_estim_val -- 线上评估价值
    ,estim_way_cd -- 评估方式代码
    ,formal_estim_val -- 正式评估价值
    ,house_area -- 房屋面积
    ,build_year -- 建成年份
    ,ths_tm_mtg_flg -- 本次抵押标志
    ,empty_flg -- 清房标志
    ,vacy_flg -- 空置标志
    ,rent_flg -- 出租标志
    ,rent_dt -- 出租日期
    ,get_house_dt -- 取房日期
    ,get_house_way_cd -- 取房方式代码
    ,prop_exp_dt -- 产权到期日期
    ,prop_co_ownr_rela_cd -- 产权共有人关系代码
    ,lh_obg_cd -- 上手权利人代码
    ,lh_mtg_amt -- 上手抵押金额
    ,land_char_cd -- 土地性质代码
    ,basm_flg -- 地下室标志
    ,arch_area -- 建筑面积
    ,land_up_area -- 地上面积
    ,land_next_area -- 地下面积
    ,resv_house_qtty -- 备用房数量
    ,resv_house_empty_flg -- 备用房清房标志
    ,resv_house_addr -- 备用房地址
    ,entry_dt -- 入抵日期
    ,relief_dt -- 解抵日期
    ,main_debit_ps_obg_flg -- 主借人权利人标志
    ,spouse_obg_flg -- 配偶权利人标志
    ,house_usage -- 房屋用途
    ,tot_floor_cnt -- 总楼层数
    ,house_num_id -- 房号编号
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,house_stru_type_descb -- 房屋结构类型描述
    ,merchd_house_char_cd -- 商品房性质代码
    ,evlbld_house_flg -- 电梯楼标志
    ,own_situ_comnt -- 共有情况说明
    ,bk_price -- 贝壳网房产评估价值
    ,tentry_name -- 承租人姓名
    ,rent_begin_dt -- 租赁起始日期
    ,rent_termnt_dt -- 租赁终止日期
    ,tentry_cert_type_cd -- 承租人证件类型代码
    ,tentry_cert_no -- 承租人证件号码
    ,mon_rent -- 月租金
    ,rent_coll_ped -- 租金收缴周期
    ,rela_ps_type_cd -- 关联人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_fkd_estate_info_icmsf1_op(
            estate_list_id -- 房产列表编号
    ,asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,city_cd -- 城市代码
    ,city_name -- 城市名称
    ,rg_cd -- 区域代码
    ,rg_name -- 区域名称
    ,estat_id -- 楼盘编号
    ,comm_addr -- 小区地址
    ,estat_position -- 楼盘位置
    ,estate_type_cd -- 房产类型代码
    ,house_id -- 楼编号
    ,floor_num -- 楼层号
    ,unit_num -- 单元室号
    ,estate_fitmt_situ_cd -- 房产装修情况代码
    ,orient_cd -- 朝向代码
    ,estim_corp_name -- 评估机构名称
    ,onl_estim_val -- 线上评估价值
    ,estim_way_cd -- 评估方式代码
    ,formal_estim_val -- 正式评估价值
    ,house_area -- 房屋面积
    ,build_year -- 建成年份
    ,ths_tm_mtg_flg -- 本次抵押标志
    ,empty_flg -- 清房标志
    ,vacy_flg -- 空置标志
    ,rent_flg -- 出租标志
    ,rent_dt -- 出租日期
    ,get_house_dt -- 取房日期
    ,get_house_way_cd -- 取房方式代码
    ,prop_exp_dt -- 产权到期日期
    ,prop_co_ownr_rela_cd -- 产权共有人关系代码
    ,lh_obg_cd -- 上手权利人代码
    ,lh_mtg_amt -- 上手抵押金额
    ,land_char_cd -- 土地性质代码
    ,basm_flg -- 地下室标志
    ,arch_area -- 建筑面积
    ,land_up_area -- 地上面积
    ,land_next_area -- 地下面积
    ,resv_house_qtty -- 备用房数量
    ,resv_house_empty_flg -- 备用房清房标志
    ,resv_house_addr -- 备用房地址
    ,entry_dt -- 入抵日期
    ,relief_dt -- 解抵日期
    ,main_debit_ps_obg_flg -- 主借人权利人标志
    ,spouse_obg_flg -- 配偶权利人标志
    ,house_usage -- 房屋用途
    ,tot_floor_cnt -- 总楼层数
    ,house_num_id -- 房号编号
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,house_stru_type_descb -- 房屋结构类型描述
    ,merchd_house_char_cd -- 商品房性质代码
    ,evlbld_house_flg -- 电梯楼标志
    ,own_situ_comnt -- 共有情况说明
    ,bk_price -- 贝壳网房产评估价值
    ,tentry_name -- 承租人姓名
    ,rent_begin_dt -- 租赁起始日期
    ,rent_termnt_dt -- 租赁终止日期
    ,tentry_cert_type_cd -- 承租人证件类型代码
    ,tentry_cert_no -- 承租人证件号码
    ,mon_rent -- 月租金
    ,rent_coll_ped -- 租金收缴周期
    ,rela_ps_type_cd -- 关联人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.estate_list_id, o.estate_list_id) as estate_list_id -- 房产列表编号
    ,nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bus_flow_num, o.bus_flow_num) as bus_flow_num -- 业务流水号
    ,nvl(n.city_cd, o.city_cd) as city_cd -- 城市代码
    ,nvl(n.city_name, o.city_name) as city_name -- 城市名称
    ,nvl(n.rg_cd, o.rg_cd) as rg_cd -- 区域代码
    ,nvl(n.rg_name, o.rg_name) as rg_name -- 区域名称
    ,nvl(n.estat_id, o.estat_id) as estat_id -- 楼盘编号
    ,nvl(n.comm_addr, o.comm_addr) as comm_addr -- 小区地址
    ,nvl(n.estat_position, o.estat_position) as estat_position -- 楼盘位置
    ,nvl(n.estate_type_cd, o.estate_type_cd) as estate_type_cd -- 房产类型代码
    ,nvl(n.house_id, o.house_id) as house_id -- 楼编号
    ,nvl(n.floor_num, o.floor_num) as floor_num -- 楼层号
    ,nvl(n.unit_num, o.unit_num) as unit_num -- 单元室号
    ,nvl(n.estate_fitmt_situ_cd, o.estate_fitmt_situ_cd) as estate_fitmt_situ_cd -- 房产装修情况代码
    ,nvl(n.orient_cd, o.orient_cd) as orient_cd -- 朝向代码
    ,nvl(n.estim_corp_name, o.estim_corp_name) as estim_corp_name -- 评估机构名称
    ,nvl(n.onl_estim_val, o.onl_estim_val) as onl_estim_val -- 线上评估价值
    ,nvl(n.estim_way_cd, o.estim_way_cd) as estim_way_cd -- 评估方式代码
    ,nvl(n.formal_estim_val, o.formal_estim_val) as formal_estim_val -- 正式评估价值
    ,nvl(n.house_area, o.house_area) as house_area -- 房屋面积
    ,nvl(n.build_year, o.build_year) as build_year -- 建成年份
    ,nvl(n.ths_tm_mtg_flg, o.ths_tm_mtg_flg) as ths_tm_mtg_flg -- 本次抵押标志
    ,nvl(n.empty_flg, o.empty_flg) as empty_flg -- 清房标志
    ,nvl(n.vacy_flg, o.vacy_flg) as vacy_flg -- 空置标志
    ,nvl(n.rent_flg, o.rent_flg) as rent_flg -- 出租标志
    ,nvl(n.rent_dt, o.rent_dt) as rent_dt -- 出租日期
    ,nvl(n.get_house_dt, o.get_house_dt) as get_house_dt -- 取房日期
    ,nvl(n.get_house_way_cd, o.get_house_way_cd) as get_house_way_cd -- 取房方式代码
    ,nvl(n.prop_exp_dt, o.prop_exp_dt) as prop_exp_dt -- 产权到期日期
    ,nvl(n.prop_co_ownr_rela_cd, o.prop_co_ownr_rela_cd) as prop_co_ownr_rela_cd -- 产权共有人关系代码
    ,nvl(n.lh_obg_cd, o.lh_obg_cd) as lh_obg_cd -- 上手权利人代码
    ,nvl(n.lh_mtg_amt, o.lh_mtg_amt) as lh_mtg_amt -- 上手抵押金额
    ,nvl(n.land_char_cd, o.land_char_cd) as land_char_cd -- 土地性质代码
    ,nvl(n.basm_flg, o.basm_flg) as basm_flg -- 地下室标志
    ,nvl(n.arch_area, o.arch_area) as arch_area -- 建筑面积
    ,nvl(n.land_up_area, o.land_up_area) as land_up_area -- 地上面积
    ,nvl(n.land_next_area, o.land_next_area) as land_next_area -- 地下面积
    ,nvl(n.resv_house_qtty, o.resv_house_qtty) as resv_house_qtty -- 备用房数量
    ,nvl(n.resv_house_empty_flg, o.resv_house_empty_flg) as resv_house_empty_flg -- 备用房清房标志
    ,nvl(n.resv_house_addr, o.resv_house_addr) as resv_house_addr -- 备用房地址
    ,nvl(n.entry_dt, o.entry_dt) as entry_dt -- 入抵日期
    ,nvl(n.relief_dt, o.relief_dt) as relief_dt -- 解抵日期
    ,nvl(n.main_debit_ps_obg_flg, o.main_debit_ps_obg_flg) as main_debit_ps_obg_flg -- 主借人权利人标志
    ,nvl(n.spouse_obg_flg, o.spouse_obg_flg) as spouse_obg_flg -- 配偶权利人标志
    ,nvl(n.house_usage, o.house_usage) as house_usage -- 房屋用途
    ,nvl(n.tot_floor_cnt, o.tot_floor_cnt) as tot_floor_cnt -- 总楼层数
    ,nvl(n.house_num_id, o.house_num_id) as house_num_id -- 房号编号
    ,nvl(n.land_use_right_begin_dt, o.land_use_right_begin_dt) as land_use_right_begin_dt -- 土地使用权起始日期
    ,nvl(n.house_stru_type_descb, o.house_stru_type_descb) as house_stru_type_descb -- 房屋结构类型描述
    ,nvl(n.merchd_house_char_cd, o.merchd_house_char_cd) as merchd_house_char_cd -- 商品房性质代码
    ,nvl(n.evlbld_house_flg, o.evlbld_house_flg) as evlbld_house_flg -- 电梯楼标志
    ,nvl(n.own_situ_comnt, o.own_situ_comnt) as own_situ_comnt -- 共有情况说明
    ,nvl(n.bk_price, o.bk_price) as bk_price -- 贝壳网房产评估价值
    ,nvl(n.tentry_name, o.tentry_name) as tentry_name -- 承租人姓名
    ,nvl(n.rent_begin_dt, o.rent_begin_dt) as rent_begin_dt -- 租赁起始日期
    ,nvl(n.rent_termnt_dt, o.rent_termnt_dt) as rent_termnt_dt -- 租赁终止日期
    ,nvl(n.tentry_cert_type_cd, o.tentry_cert_type_cd) as tentry_cert_type_cd -- 承租人证件类型代码
    ,nvl(n.tentry_cert_no, o.tentry_cert_no) as tentry_cert_no -- 承租人证件号码
    ,nvl(n.mon_rent, o.mon_rent) as mon_rent -- 月租金
    ,nvl(n.rent_coll_ped, o.rent_coll_ped) as rent_coll_ped -- 租金收缴周期
    ,nvl(n.rela_ps_type_cd, o.rela_ps_type_cd) as rela_ps_type_cd -- 关联人类型代码
    ,case when
            n.estate_list_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.estate_list_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.estate_list_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_fkd_estate_info_icmsf1_tm n
    full join (select * from ${iml_schema}.ast_fkd_estate_info_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.estate_list_id = n.estate_list_id
            and o.lp_id = n.lp_id
where (
        o.estate_list_id is null
        and o.lp_id is null
    )
    or (
        n.estate_list_id is null
        and n.lp_id is null
    )
    or (
        o.asset_id <> n.asset_id
        or o.bus_flow_num <> n.bus_flow_num
        or o.city_cd <> n.city_cd
        or o.city_name <> n.city_name
        or o.rg_cd <> n.rg_cd
        or o.rg_name <> n.rg_name
        or o.estat_id <> n.estat_id
        or o.comm_addr <> n.comm_addr
        or o.estat_position <> n.estat_position
        or o.estate_type_cd <> n.estate_type_cd
        or o.house_id <> n.house_id
        or o.floor_num <> n.floor_num
        or o.unit_num <> n.unit_num
        or o.estate_fitmt_situ_cd <> n.estate_fitmt_situ_cd
        or o.orient_cd <> n.orient_cd
        or o.estim_corp_name <> n.estim_corp_name
        or o.onl_estim_val <> n.onl_estim_val
        or o.estim_way_cd <> n.estim_way_cd
        or o.formal_estim_val <> n.formal_estim_val
        or o.house_area <> n.house_area
        or o.build_year <> n.build_year
        or o.ths_tm_mtg_flg <> n.ths_tm_mtg_flg
        or o.empty_flg <> n.empty_flg
        or o.vacy_flg <> n.vacy_flg
        or o.rent_flg <> n.rent_flg
        or o.rent_dt <> n.rent_dt
        or o.get_house_dt <> n.get_house_dt
        or o.get_house_way_cd <> n.get_house_way_cd
        or o.prop_exp_dt <> n.prop_exp_dt
        or o.prop_co_ownr_rela_cd <> n.prop_co_ownr_rela_cd
        or o.lh_obg_cd <> n.lh_obg_cd
        or o.lh_mtg_amt <> n.lh_mtg_amt
        or o.land_char_cd <> n.land_char_cd
        or o.basm_flg <> n.basm_flg
        or o.arch_area <> n.arch_area
        or o.land_up_area <> n.land_up_area
        or o.land_next_area <> n.land_next_area
        or o.resv_house_qtty <> n.resv_house_qtty
        or o.resv_house_empty_flg <> n.resv_house_empty_flg
        or o.resv_house_addr <> n.resv_house_addr
        or o.entry_dt <> n.entry_dt
        or o.relief_dt <> n.relief_dt
        or o.main_debit_ps_obg_flg <> n.main_debit_ps_obg_flg
        or o.spouse_obg_flg <> n.spouse_obg_flg
        or o.house_usage <> n.house_usage
        or o.tot_floor_cnt <> n.tot_floor_cnt
        or o.house_num_id <> n.house_num_id
        or o.land_use_right_begin_dt <> n.land_use_right_begin_dt
        or o.house_stru_type_descb <> n.house_stru_type_descb
        or o.merchd_house_char_cd <> n.merchd_house_char_cd
        or o.evlbld_house_flg <> n.evlbld_house_flg
        or o.own_situ_comnt <> n.own_situ_comnt
        or o.bk_price <> n.bk_price
        or o.tentry_name <> n.tentry_name
        or o.rent_begin_dt <> n.rent_begin_dt
        or o.rent_termnt_dt <> n.rent_termnt_dt
        or o.tentry_cert_type_cd <> n.tentry_cert_type_cd
        or o.tentry_cert_no <> n.tentry_cert_no
        or o.mon_rent <> n.mon_rent
        or o.rent_coll_ped <> n.rent_coll_ped
        or o.rela_ps_type_cd <> n.rela_ps_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_fkd_estate_info_icmsf1_cl(
            estate_list_id -- 房产列表编号
    ,asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,city_cd -- 城市代码
    ,city_name -- 城市名称
    ,rg_cd -- 区域代码
    ,rg_name -- 区域名称
    ,estat_id -- 楼盘编号
    ,comm_addr -- 小区地址
    ,estat_position -- 楼盘位置
    ,estate_type_cd -- 房产类型代码
    ,house_id -- 楼编号
    ,floor_num -- 楼层号
    ,unit_num -- 单元室号
    ,estate_fitmt_situ_cd -- 房产装修情况代码
    ,orient_cd -- 朝向代码
    ,estim_corp_name -- 评估机构名称
    ,onl_estim_val -- 线上评估价值
    ,estim_way_cd -- 评估方式代码
    ,formal_estim_val -- 正式评估价值
    ,house_area -- 房屋面积
    ,build_year -- 建成年份
    ,ths_tm_mtg_flg -- 本次抵押标志
    ,empty_flg -- 清房标志
    ,vacy_flg -- 空置标志
    ,rent_flg -- 出租标志
    ,rent_dt -- 出租日期
    ,get_house_dt -- 取房日期
    ,get_house_way_cd -- 取房方式代码
    ,prop_exp_dt -- 产权到期日期
    ,prop_co_ownr_rela_cd -- 产权共有人关系代码
    ,lh_obg_cd -- 上手权利人代码
    ,lh_mtg_amt -- 上手抵押金额
    ,land_char_cd -- 土地性质代码
    ,basm_flg -- 地下室标志
    ,arch_area -- 建筑面积
    ,land_up_area -- 地上面积
    ,land_next_area -- 地下面积
    ,resv_house_qtty -- 备用房数量
    ,resv_house_empty_flg -- 备用房清房标志
    ,resv_house_addr -- 备用房地址
    ,entry_dt -- 入抵日期
    ,relief_dt -- 解抵日期
    ,main_debit_ps_obg_flg -- 主借人权利人标志
    ,spouse_obg_flg -- 配偶权利人标志
    ,house_usage -- 房屋用途
    ,tot_floor_cnt -- 总楼层数
    ,house_num_id -- 房号编号
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,house_stru_type_descb -- 房屋结构类型描述
    ,merchd_house_char_cd -- 商品房性质代码
    ,evlbld_house_flg -- 电梯楼标志
    ,own_situ_comnt -- 共有情况说明
    ,bk_price -- 贝壳网房产评估价值
    ,tentry_name -- 承租人姓名
    ,rent_begin_dt -- 租赁起始日期
    ,rent_termnt_dt -- 租赁终止日期
    ,tentry_cert_type_cd -- 承租人证件类型代码
    ,tentry_cert_no -- 承租人证件号码
    ,mon_rent -- 月租金
    ,rent_coll_ped -- 租金收缴周期
    ,rela_ps_type_cd -- 关联人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_fkd_estate_info_icmsf1_op(
            estate_list_id -- 房产列表编号
    ,asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,city_cd -- 城市代码
    ,city_name -- 城市名称
    ,rg_cd -- 区域代码
    ,rg_name -- 区域名称
    ,estat_id -- 楼盘编号
    ,comm_addr -- 小区地址
    ,estat_position -- 楼盘位置
    ,estate_type_cd -- 房产类型代码
    ,house_id -- 楼编号
    ,floor_num -- 楼层号
    ,unit_num -- 单元室号
    ,estate_fitmt_situ_cd -- 房产装修情况代码
    ,orient_cd -- 朝向代码
    ,estim_corp_name -- 评估机构名称
    ,onl_estim_val -- 线上评估价值
    ,estim_way_cd -- 评估方式代码
    ,formal_estim_val -- 正式评估价值
    ,house_area -- 房屋面积
    ,build_year -- 建成年份
    ,ths_tm_mtg_flg -- 本次抵押标志
    ,empty_flg -- 清房标志
    ,vacy_flg -- 空置标志
    ,rent_flg -- 出租标志
    ,rent_dt -- 出租日期
    ,get_house_dt -- 取房日期
    ,get_house_way_cd -- 取房方式代码
    ,prop_exp_dt -- 产权到期日期
    ,prop_co_ownr_rela_cd -- 产权共有人关系代码
    ,lh_obg_cd -- 上手权利人代码
    ,lh_mtg_amt -- 上手抵押金额
    ,land_char_cd -- 土地性质代码
    ,basm_flg -- 地下室标志
    ,arch_area -- 建筑面积
    ,land_up_area -- 地上面积
    ,land_next_area -- 地下面积
    ,resv_house_qtty -- 备用房数量
    ,resv_house_empty_flg -- 备用房清房标志
    ,resv_house_addr -- 备用房地址
    ,entry_dt -- 入抵日期
    ,relief_dt -- 解抵日期
    ,main_debit_ps_obg_flg -- 主借人权利人标志
    ,spouse_obg_flg -- 配偶权利人标志
    ,house_usage -- 房屋用途
    ,tot_floor_cnt -- 总楼层数
    ,house_num_id -- 房号编号
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,house_stru_type_descb -- 房屋结构类型描述
    ,merchd_house_char_cd -- 商品房性质代码
    ,evlbld_house_flg -- 电梯楼标志
    ,own_situ_comnt -- 共有情况说明
    ,bk_price -- 贝壳网房产评估价值
    ,tentry_name -- 承租人姓名
    ,rent_begin_dt -- 租赁起始日期
    ,rent_termnt_dt -- 租赁终止日期
    ,tentry_cert_type_cd -- 承租人证件类型代码
    ,tentry_cert_no -- 承租人证件号码
    ,mon_rent -- 月租金
    ,rent_coll_ped -- 租金收缴周期
    ,rela_ps_type_cd -- 关联人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.estate_list_id -- 房产列表编号
    ,o.asset_id -- 资产编号
    ,o.lp_id -- 法人编号
    ,o.bus_flow_num -- 业务流水号
    ,o.city_cd -- 城市代码
    ,o.city_name -- 城市名称
    ,o.rg_cd -- 区域代码
    ,o.rg_name -- 区域名称
    ,o.estat_id -- 楼盘编号
    ,o.comm_addr -- 小区地址
    ,o.estat_position -- 楼盘位置
    ,o.estate_type_cd -- 房产类型代码
    ,o.house_id -- 楼编号
    ,o.floor_num -- 楼层号
    ,o.unit_num -- 单元室号
    ,o.estate_fitmt_situ_cd -- 房产装修情况代码
    ,o.orient_cd -- 朝向代码
    ,o.estim_corp_name -- 评估机构名称
    ,o.onl_estim_val -- 线上评估价值
    ,o.estim_way_cd -- 评估方式代码
    ,o.formal_estim_val -- 正式评估价值
    ,o.house_area -- 房屋面积
    ,o.build_year -- 建成年份
    ,o.ths_tm_mtg_flg -- 本次抵押标志
    ,o.empty_flg -- 清房标志
    ,o.vacy_flg -- 空置标志
    ,o.rent_flg -- 出租标志
    ,o.rent_dt -- 出租日期
    ,o.get_house_dt -- 取房日期
    ,o.get_house_way_cd -- 取房方式代码
    ,o.prop_exp_dt -- 产权到期日期
    ,o.prop_co_ownr_rela_cd -- 产权共有人关系代码
    ,o.lh_obg_cd -- 上手权利人代码
    ,o.lh_mtg_amt -- 上手抵押金额
    ,o.land_char_cd -- 土地性质代码
    ,o.basm_flg -- 地下室标志
    ,o.arch_area -- 建筑面积
    ,o.land_up_area -- 地上面积
    ,o.land_next_area -- 地下面积
    ,o.resv_house_qtty -- 备用房数量
    ,o.resv_house_empty_flg -- 备用房清房标志
    ,o.resv_house_addr -- 备用房地址
    ,o.entry_dt -- 入抵日期
    ,o.relief_dt -- 解抵日期
    ,o.main_debit_ps_obg_flg -- 主借人权利人标志
    ,o.spouse_obg_flg -- 配偶权利人标志
    ,o.house_usage -- 房屋用途
    ,o.tot_floor_cnt -- 总楼层数
    ,o.house_num_id -- 房号编号
    ,o.land_use_right_begin_dt -- 土地使用权起始日期
    ,o.house_stru_type_descb -- 房屋结构类型描述
    ,o.merchd_house_char_cd -- 商品房性质代码
    ,o.evlbld_house_flg -- 电梯楼标志
    ,o.own_situ_comnt -- 共有情况说明
    ,o.bk_price -- 贝壳网房产评估价值
    ,o.tentry_name -- 承租人姓名
    ,o.rent_begin_dt -- 租赁起始日期
    ,o.rent_termnt_dt -- 租赁终止日期
    ,o.tentry_cert_type_cd -- 承租人证件类型代码
    ,o.tentry_cert_no -- 承租人证件号码
    ,o.mon_rent -- 月租金
    ,o.rent_coll_ped -- 租金收缴周期
    ,o.rela_ps_type_cd -- 关联人类型代码
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
from ${iml_schema}.ast_fkd_estate_info_icmsf1_bk o
    left join ${iml_schema}.ast_fkd_estate_info_icmsf1_op n
        on
            o.estate_list_id = n.estate_list_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_fkd_estate_info_icmsf1_cl d
        on
            o.estate_list_id = d.estate_list_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_fkd_estate_info;
--alter table ${iml_schema}.ast_fkd_estate_info truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ast_fkd_estate_info') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ast_fkd_estate_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_fkd_estate_info modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ast_fkd_estate_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ast_fkd_estate_info_icmsf1_cl;
alter table ${iml_schema}.ast_fkd_estate_info exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.ast_fkd_estate_info_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_fkd_estate_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_fkd_estate_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_fkd_estate_info_icmsf1_op purge;
drop table ${iml_schema}.ast_fkd_estate_info_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_fkd_estate_info_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_fkd_estate_info', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
