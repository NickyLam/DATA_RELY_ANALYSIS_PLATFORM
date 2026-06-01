/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ast_col_comer_build_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.ast_col_comer_build_info
whenever sqlerror continue none;
drop table ${idl_schema}.ast_col_comer_build_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.ast_col_comer_build_info(
    etl_dt date -- 数据日期   
    ,asset_id varchar2(60) -- 资产编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,house_used_flg varchar2(30) -- 一手二手标志   
    ,two_in_one_flg varchar2(30) -- 两证合一标志   
    ,rel_esat_wat_id varchar2(250) -- 不动产权证编号   
    ,all_mtg_flg varchar2(30) -- 全部抵押标志   
    ,bs_cont_id varchar2(60) -- 买卖合同编号   
    ,buy_dt date -- 购房日期   
    ,buy_amt number(30,2) -- 购房金额   
    ,arch_area number(30,2) -- 建筑面积   
    ,usbl_area number(30,2) -- 实用面积   
    ,build_year varchar2(30) -- 建成年份   
    ,build_age number(30,2) -- 楼龄   
    ,stru_type_cd varchar2(30) -- 结构类型代码   
    ,local_prov_cd varchar2(60) -- 所在省代码   
    ,local_city_cd varchar2(60) -- 所在市代码   
    ,local_rg_cd varchar2(60) -- 所在区代码   
    ,street_name varchar2(100) -- 街道名称   
    ,dplat_id varchar2(100) -- 门牌编号   
    ,rel_esat_wat_rgst_addr varchar2(250) -- 不动产权证登记地址   
    ,floor_cnt varchar2(60) -- 楼层数   
    ,tot_floor_cnt number(10) -- 总楼层数   
    ,status_cd varchar2(30) -- 状态代码   
    ,prop_tenor number(30,2) -- 产权期限   
    ,land_use_right_id varchar2(250) -- 土地使用权证编号   
    ,land_char_cd varchar2(30) -- 土地所有权性质代码   
    ,land_get_way_cd varchar2(30) -- 土地取得方式代码   
    ,land_use_right_begin_dt date -- 土地使用权起始日期   
    ,land_use_right_exp_dt date -- 土地使用权到期日期   
    ,land_use_right_years number(30,2) -- 土地使用权年限   
    ,land_usage_cd varchar2(30) -- 土地用途代码   
    ,other_prop_cert_flg varchar2(30) -- 已有他项权证标志   
    ,other_comnt varchar2(4000) -- 其他说明   
    ,rent_flg varchar2(30) -- 出租标志   
    ,tentry_name varchar2(100) -- 承租人名称   
    ,rent_begin_dt date -- 出租起始日期   
    ,rent_exp_dt date -- 出租到期日期   
    ,rent_situ_comnt varchar2(250) -- 出租情况说明   
    ,curr_cd varchar2(30) -- 币种代码   
    ,prop_surp_tenor number(10) -- 产权剩余期限   
    ,monly_mgmt_fee number(30,2) -- 每月管理费   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识
    ,job_cd varchar2(10) -- 任务编码    
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ast_col_comer_build_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.ast_col_comer_build_info is '押品商业用房信息';
comment on column ${idl_schema}.ast_col_comer_build_info.etl_dt is '数据日期';
comment on column ${idl_schema}.ast_col_comer_build_info.asset_id is '资产编号';
comment on column ${idl_schema}.ast_col_comer_build_info.lp_id is '法人编号';
comment on column ${idl_schema}.ast_col_comer_build_info.house_used_flg is '一手二手标志';
comment on column ${idl_schema}.ast_col_comer_build_info.two_in_one_flg is '两证合一标志';
comment on column ${idl_schema}.ast_col_comer_build_info.rel_esat_wat_id is '不动产权证编号';
comment on column ${idl_schema}.ast_col_comer_build_info.all_mtg_flg is '全部抵押标志';
comment on column ${idl_schema}.ast_col_comer_build_info.bs_cont_id is '买卖合同编号';
comment on column ${idl_schema}.ast_col_comer_build_info.buy_dt is '购房日期';
comment on column ${idl_schema}.ast_col_comer_build_info.buy_amt is '购房金额';
comment on column ${idl_schema}.ast_col_comer_build_info.arch_area is '建筑面积';
comment on column ${idl_schema}.ast_col_comer_build_info.usbl_area is '实用面积';
comment on column ${idl_schema}.ast_col_comer_build_info.build_year is '建成年份';
comment on column ${idl_schema}.ast_col_comer_build_info.build_age is '楼龄';
comment on column ${idl_schema}.ast_col_comer_build_info.stru_type_cd is '结构类型代码';
comment on column ${idl_schema}.ast_col_comer_build_info.local_prov_cd is '所在省代码';
comment on column ${idl_schema}.ast_col_comer_build_info.local_city_cd is '所在市代码';
comment on column ${idl_schema}.ast_col_comer_build_info.local_rg_cd is '所在区代码';
comment on column ${idl_schema}.ast_col_comer_build_info.street_name is '街道名称';
comment on column ${idl_schema}.ast_col_comer_build_info.dplat_id is '门牌编号';
comment on column ${idl_schema}.ast_col_comer_build_info.rel_esat_wat_rgst_addr is '不动产权证登记地址';
comment on column ${idl_schema}.ast_col_comer_build_info.floor_cnt is '楼层数';
comment on column ${idl_schema}.ast_col_comer_build_info.tot_floor_cnt is '总楼层数';
comment on column ${idl_schema}.ast_col_comer_build_info.status_cd is '状态代码';
comment on column ${idl_schema}.ast_col_comer_build_info.prop_tenor is '产权期限';
comment on column ${idl_schema}.ast_col_comer_build_info.land_use_right_id is '土地使用权证编号';
comment on column ${idl_schema}.ast_col_comer_build_info.land_char_cd is '土地所有权性质代码';
comment on column ${idl_schema}.ast_col_comer_build_info.land_get_way_cd is '土地取得方式代码';
comment on column ${idl_schema}.ast_col_comer_build_info.land_use_right_begin_dt is '土地使用权起始日期';
comment on column ${idl_schema}.ast_col_comer_build_info.land_use_right_exp_dt is '土地使用权到期日期';
comment on column ${idl_schema}.ast_col_comer_build_info.land_use_right_years is '土地使用权年限';
comment on column ${idl_schema}.ast_col_comer_build_info.land_usage_cd is '土地用途代码';
comment on column ${idl_schema}.ast_col_comer_build_info.other_prop_cert_flg is '已有他项权证标志';
comment on column ${idl_schema}.ast_col_comer_build_info.other_comnt is '其他说明';
comment on column ${idl_schema}.ast_col_comer_build_info.rent_flg is '出租标志';
comment on column ${idl_schema}.ast_col_comer_build_info.tentry_name is '承租人名称';
comment on column ${idl_schema}.ast_col_comer_build_info.rent_begin_dt is '出租起始日期';
comment on column ${idl_schema}.ast_col_comer_build_info.rent_exp_dt is '出租到期日期';
comment on column ${idl_schema}.ast_col_comer_build_info.rent_situ_comnt is '出租情况说明';
comment on column ${idl_schema}.ast_col_comer_build_info.curr_cd is '币种代码';
comment on column ${idl_schema}.ast_col_comer_build_info.prop_surp_tenor is '产权剩余期限';
comment on column ${idl_schema}.ast_col_comer_build_info.monly_mgmt_fee is '每月管理费';
comment on column ${idl_schema}.ast_col_comer_build_info.create_dt is '创建日期';
comment on column ${idl_schema}.ast_col_comer_build_info.update_dt is '更新日期';
comment on column ${idl_schema}.ast_col_comer_build_info.id_mark is '删除标识';