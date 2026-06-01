/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_fkd_estate_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_fkd_estate_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_fkd_estate_info(
etl_dt date --数据日期
,lp_id varchar2(60) --法人编号
,bus_flow_num varchar2(200) --业务流水号
,city_cd varchar2(60) --城市代码
,city_name varchar2(500) --城市名称
,rg_cd varchar2(60) --区域代码
,rg_name varchar2(500) --区域名称
,estat_id varchar2(200) --楼盘编号
,comm_addr varchar2(1000) --小区地址
,estat_position varchar2(1000) --楼盘位置
,estate_type_cd varchar2(60) --房产类型代码
,house_id varchar2(200) --楼编号
,floor_num varchar2(60) --楼层号
,unit_num varchar2(60) --单元室号
,estate_fitmt_situ_cd varchar2(60) --房产装修情况代码
,orient_cd varchar2(60) --朝向代码
,estim_corp_name varchar2(500) --评估机构名称
,onl_estim_val number(30,2) --线上评估价值
,estim_way_cd varchar2(30) --评估方式代码
,formal_estim_val number(30,2) --正式评估价值
,house_area number(30,2) --房屋面积
,build_year number(30,0) --建成年份
,ths_tm_mtg_flg varchar2(10) --本次抵押标志
,empty_flg varchar2(30) --清房标志
,vacy_flg varchar2(30) --空置标志
,rent_flg varchar2(30) --出租标志
,rent_dt date --出租日期
,get_house_dt date --取房日期
,get_house_way_cd varchar2(60) --取房方式代码
,prop_exp_dt varchar2(20) --产权到期日期
,prop_co_ownr_rela_cd varchar2(250) --产权共有人关系代码
,lh_obg_cd varchar2(60) --上手权利人代码
,lh_mtg_amt number(30,8) --上手抵押金额
,land_char_cd varchar2(60) --土地性质代码
,basm_flg varchar2(10) --地下室标志
,arch_area number(30,2) --建筑面积
,land_up_area number(30,2) --地上面积
,land_next_area number(30,2) --地下面积
,resv_house_qtty number(10,0) --备用房数量
,resv_house_empty_flg varchar2(30) --备用房清房标志
,resv_house_addr varchar2(1000) --备用房地址
,entry_dt date --入抵日期
,relief_dt date --解抵日期
,main_debit_ps_obg_flg varchar2(10) --主借人权利人标志
,spouse_obg_flg varchar2(10) --配偶权利人标志
,house_usage varchar2(60) --房屋用途
,tot_floor_cnt number(20,0) --总楼层数
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,estate_list_id varchar2(200) --房产列表编号
,asset_id varchar2(60) --资产编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_ast_fkd_estate_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_fkd_estate_info is '房快贷房产信息';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.lp_id is '法人编号';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.bus_flow_num is '业务流水号';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.city_cd is '城市代码';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.city_name is '城市名称';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.rg_cd is '区域代码';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.rg_name is '区域名称';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.estat_id is '楼盘编号';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.comm_addr is '小区地址';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.estat_position is '楼盘位置';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.estate_type_cd is '房产类型代码';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.house_id is '楼编号';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.floor_num is '楼层号';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.unit_num is '单元室号';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.estate_fitmt_situ_cd is '房产装修情况代码';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.orient_cd is '朝向代码';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.estim_corp_name is '评估机构名称';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.onl_estim_val is '线上评估价值';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.estim_way_cd is '评估方式代码';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.formal_estim_val is '正式评估价值';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.house_area is '房屋面积';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.build_year is '建成年份';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.ths_tm_mtg_flg is '本次抵押标志';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.empty_flg is '清房标志';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.vacy_flg is '空置标志';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.rent_flg is '出租标志';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.rent_dt is '出租日期';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.get_house_dt is '取房日期';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.get_house_way_cd is '取房方式代码';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.prop_exp_dt is '产权到期日期';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.prop_co_ownr_rela_cd is '产权共有人关系代码';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.lh_obg_cd is '上手权利人代码';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.lh_mtg_amt is '上手抵押金额';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.land_char_cd is '土地性质代码';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.basm_flg is '地下室标志';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.arch_area is '建筑面积';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.land_up_area is '地上面积';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.land_next_area is '地下面积';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.resv_house_qtty is '备用房数量';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.resv_house_empty_flg is '备用房清房标志';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.resv_house_addr is '备用房地址';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.entry_dt is '入抵日期';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.relief_dt is '解抵日期';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.main_debit_ps_obg_flg is '主借人权利人标志';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.spouse_obg_flg is '配偶权利人标志';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.house_usage is '房屋用途';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.tot_floor_cnt is '总楼层数';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.start_dt is '开始时间';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.end_dt is '结束时间';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.estate_list_id is '房产列表编号';
comment on column ${idl_schema}.oass_ast_fkd_estate_info.asset_id is '资产编号';

