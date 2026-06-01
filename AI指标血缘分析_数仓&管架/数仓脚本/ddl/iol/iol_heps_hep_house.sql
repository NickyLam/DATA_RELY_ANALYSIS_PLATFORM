/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_hep_house
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_hep_house
whenever sqlerror continue none;
drop table ${iol_schema}.heps_hep_house purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_hep_house(
    house_id number -- 房产id
    ,flow_id varchar2(50) -- 业务流水号
    ,house_type varchar2(20) -- 房产类型(0:普通住宅 1:商业住宅)
    ,is_basement varchar2(3) -- 地下室(0:无  1:有)
    ,plot_name varchar2(200) -- 小区名称
    ,online_valuation number(32,10) -- 线上评估价值
    ,house_area number(32,10) -- 房屋面积
    ,house_location varchar2(500) -- 房产证位置
    ,completion_year varchar2(10) -- 建成年份
    ,total_tier varchar2(10) -- 总楼层
    ,spare_house varchar2(5) -- 备用房数量
    ,property_start_time varchar2(10) -- 土地使用权起始日期
    ,property_end_time varchar2(10) -- 土地使用权到期日期
    ,is_vacancy varchar2(10) -- 是否空置(0:否  1:是)
    ,start_obligee varchar2(32) -- 上手权利人
    ,property_people_count varchar2(10) -- 产权人人数
    ,property_common_relation varchar2(32) -- 产权共有人关系
    ,property_prove varchar2(32) -- 权属证明
    ,prove_no varchar2(32) -- 证明编号
    ,durable_years varchar2(32) -- 使用年限
    ,house_usage varchar2(32) -- 房屋用途
    ,assess_way varchar2(32) -- 评估方式
    ,official_valuation number(32,10) -- 正式评估价值
    ,status varchar2(32) -- 状态
    ,house_use varchar2(64) -- 房屋用途
    ,local_area varchar2(20) -- 所在区域
    ,assessment_com varchar2(64) -- 评估公司名称
    ,city_code varchar2(32) -- 城市编码
    ,sub_divide_code varchar2(32) -- 区名
    ,property_common_relation_des varchar2(600) -- 产权共有人关系备注
    ,property_get_time varchar2(10) -- 产权证书取得时间
    ,land_use varchar2(400) -- 土地用途
    ,oloan_is_circle varchar2(2) -- 原贷款是否循环
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.heps_hep_house to ${iml_schema};
grant select on ${iol_schema}.heps_hep_house to ${icl_schema};
grant select on ${iol_schema}.heps_hep_house to ${idl_schema};
grant select on ${iol_schema}.heps_hep_house to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_hep_house is '房屋信息表';
comment on column ${iol_schema}.heps_hep_house.house_id is '房产id';
comment on column ${iol_schema}.heps_hep_house.flow_id is '业务流水号';
comment on column ${iol_schema}.heps_hep_house.house_type is '房产类型(0:普通住宅 1:商业住宅)';
comment on column ${iol_schema}.heps_hep_house.is_basement is '地下室(0:无  1:有)';
comment on column ${iol_schema}.heps_hep_house.plot_name is '小区名称';
comment on column ${iol_schema}.heps_hep_house.online_valuation is '线上评估价值';
comment on column ${iol_schema}.heps_hep_house.house_area is '房屋面积';
comment on column ${iol_schema}.heps_hep_house.house_location is '房产证位置';
comment on column ${iol_schema}.heps_hep_house.completion_year is '建成年份';
comment on column ${iol_schema}.heps_hep_house.total_tier is '总楼层';
comment on column ${iol_schema}.heps_hep_house.spare_house is '备用房数量';
comment on column ${iol_schema}.heps_hep_house.property_start_time is '土地使用权起始日期';
comment on column ${iol_schema}.heps_hep_house.property_end_time is '土地使用权到期日期';
comment on column ${iol_schema}.heps_hep_house.is_vacancy is '是否空置(0:否  1:是)';
comment on column ${iol_schema}.heps_hep_house.start_obligee is '上手权利人';
comment on column ${iol_schema}.heps_hep_house.property_people_count is '产权人人数';
comment on column ${iol_schema}.heps_hep_house.property_common_relation is '产权共有人关系';
comment on column ${iol_schema}.heps_hep_house.property_prove is '权属证明';
comment on column ${iol_schema}.heps_hep_house.prove_no is '证明编号';
comment on column ${iol_schema}.heps_hep_house.durable_years is '使用年限';
comment on column ${iol_schema}.heps_hep_house.house_usage is '房屋用途';
comment on column ${iol_schema}.heps_hep_house.assess_way is '评估方式';
comment on column ${iol_schema}.heps_hep_house.official_valuation is '正式评估价值';
comment on column ${iol_schema}.heps_hep_house.status is '状态';
comment on column ${iol_schema}.heps_hep_house.house_use is '房屋用途';
comment on column ${iol_schema}.heps_hep_house.local_area is '所在区域';
comment on column ${iol_schema}.heps_hep_house.assessment_com is '评估公司名称';
comment on column ${iol_schema}.heps_hep_house.city_code is '城市编码';
comment on column ${iol_schema}.heps_hep_house.sub_divide_code is '区名';
comment on column ${iol_schema}.heps_hep_house.property_common_relation_des is '产权共有人关系备注';
comment on column ${iol_schema}.heps_hep_house.property_get_time is '产权证书取得时间';
comment on column ${iol_schema}.heps_hep_house.land_use is '土地用途';
comment on column ${iol_schema}.heps_hep_house.oloan_is_circle is '原贷款是否循环';
comment on column ${iol_schema}.heps_hep_house.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_hep_house.etl_timestamp is 'ETL处理时间戳';
