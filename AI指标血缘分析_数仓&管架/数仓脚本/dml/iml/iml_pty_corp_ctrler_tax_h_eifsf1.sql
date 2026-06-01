/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_corp_ctrler_tax_h_eifsf1
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
alter table ${iml_schema}.pty_corp_ctrler_tax_h add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_ctrler_tax_h partition for ('eifsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_op purge;
drop table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,rela_party_id -- 关联当事人编号
    ,ctrler_type_cd -- 控制人类型代码
    ,ctrler_cert_type_cd -- 控制人证件类型代码
    ,ctrler_cert_no -- 控制人证件号码
    ,ctrler_name -- 控制人名称
    ,ctrler_legal_en_last_name -- 控制人法定英文姓氏
    ,ctrler_en_mdl_name -- 控制人英文中间名
    ,ctrler_legal_en_first_name -- 控制人法定英文名字
    ,ctrler_tax_red_cty_cd_comb -- 控制人税收居民国家代码组合
    ,get_stament_flg -- 取得自证声明标志
    ,tax_num -- 纳税人识别号
    ,distr_idtfy_num_cty_cd_comb -- 发放识别号国家代码组合
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,ctrler_birth_city_name -- 控制人出生城市名称
    ,birth_cty_home_and_rg_cd -- 出生国家和地区代码
    ,ctrler_birth_cty_en_name -- 控制人出生国英文名称
    ,ctrler_cn_birth_addr -- 控制人中文出生地址
    ,ctrler_cn_resd_addr -- 控制人中文现居地址
    ,ctrler_en_resd_addr -- 控制人英文现居地址
    ,ctrler_birth_dt -- 控制人出生日期
    ,tax_resdnt_idti_cd	 -- 税收居民身份代码	
    ,cert_invalid_dt	 --证件失效日期	
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_ctrler_tax_h partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_ctrler_tax_h partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_ctrler_tax_h partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_t01_corp_control_tax_info-
insert into ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_tm(
    party_id -- 当事人编号
    ,rela_party_id -- 关联当事人编号
    ,ctrler_type_cd -- 控制人类型代码
    ,ctrler_cert_type_cd -- 控制人证件类型代码
    ,ctrler_cert_no -- 控制人证件号码
    ,ctrler_name -- 控制人名称
    ,ctrler_legal_en_last_name -- 控制人法定英文姓氏
    ,ctrler_en_mdl_name -- 控制人英文中间名
    ,ctrler_legal_en_first_name -- 控制人法定英文名字
    ,ctrler_tax_red_cty_cd_comb -- 控制人税收居民国家代码组合
    ,get_stament_flg -- 取得自证声明标志
    ,tax_num -- 纳税人识别号
    ,distr_idtfy_num_cty_cd_comb -- 发放识别号国家代码组合
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,ctrler_birth_city_name -- 控制人出生城市名称
    ,birth_cty_home_and_rg_cd -- 出生国家和地区代码
    ,ctrler_birth_cty_en_name -- 控制人出生国英文名称
    ,ctrler_cn_birth_addr -- 控制人中文出生地址
    ,ctrler_cn_resd_addr -- 控制人中文现居地址
    ,ctrler_en_resd_addr -- 控制人英文现居地址
    ,ctrler_birth_dt -- 控制人出生日期 
    ,tax_resdnt_idti_cd	 -- 税收居民身份代码	
    ,cert_invalid_dt	 --证件失效日期	
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,P1.REL_ID -- 关联当事人编号
    ,NVL(TRIM(P1.CONTROLLER_TYPE_CD）,'-') -- 控制人类型代码
    ,NVL(TRIM(P1.CONTROLLER_CERT_TYPE_CD),'0000') -- 控制人证件类型代码
    ,P1.CONTROLLER_CERT_NUM -- 控制人证件号码
    ,P1.CN_NAME -- 控制人名称
    ,P1.LEGAL_EN_FAMILY_NAME -- 控制人法定英文姓氏
    ,P1.MIDDLE_NAME -- 控制人英文中间名
    ,P1.LEGAL_EN_FIRST_NAME -- 控制人法定英文名字
    ,P1.TAX_COUNTRY -- 控制人税收居民国家代码组合
    ,NVL(TRIM(P1.CONTROLLER_TAX_STATEMENT),'-') -- 取得自证声明标志
    ,P1.TAX_NUMBER -- 纳税人识别号
    ,P1.ISSUED_BY -- 发放识别号国家代码组合
    ,P1.TAX_NULL_REASON -- 纳税人识别号空值原因描述
    ,P1.BIRTH_CITY -- 控制人出生城市名称
    ,NVL(TRIM(P1.BIRTH_COUNTRY_CD),'XXX') -- 出生国家和地区代码
    ,P1.BIRTH_COUNTRY_EN -- 控制人出生国英文名称
    ,P1.CONTROLLER_BIRTH_PLACE_CN -- 控制人中文出生地址
    ,P1.CONTROLLER_ADDRESS_CN -- 控制人中文现居地址
    ,P1.CONTROLLER_ADDRESS_EN -- 控制人英文现居地址
    ,nvl(trim(p1.BIRTH_DT),'00010101') -- 控制人出生日期
    ,NVL(trim(P1.TAX_PAY_CTZN_IDNT),'5')	 -- 税收居民身份代码	
    ,${iml_schema}.dateformat_min(P1.CERT_INVALID_DT)	 --证件失效日期	
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_control_tax_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_control_tax_info p1
    left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND p1.Updated_Ts=to_timestamp('9999-12-31 00:00:00','YYYY-MM-DD HH24:MI:SS')


;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_cl(
            party_id -- 当事人编号
    ,rela_party_id -- 关联当事人编号
    ,ctrler_type_cd -- 控制人类型代码
    ,ctrler_cert_type_cd -- 控制人证件类型代码
    ,ctrler_cert_no -- 控制人证件号码
    ,ctrler_name -- 控制人名称
    ,ctrler_legal_en_last_name -- 控制人法定英文姓氏
    ,ctrler_en_mdl_name -- 控制人英文中间名
    ,ctrler_legal_en_first_name -- 控制人法定英文名字
    ,ctrler_tax_red_cty_cd_comb -- 控制人税收居民国家代码组合
    ,get_stament_flg -- 取得自证声明标志
    ,tax_num -- 纳税人识别号
    ,distr_idtfy_num_cty_cd_comb -- 发放识别号国家代码组合
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,ctrler_birth_city_name -- 控制人出生城市名称
    ,birth_cty_home_and_rg_cd -- 出生国家和地区代码
    ,ctrler_birth_cty_en_name -- 控制人出生国英文名称
    ,ctrler_cn_birth_addr -- 控制人中文出生地址
    ,ctrler_cn_resd_addr -- 控制人中文现居地址
    ,ctrler_en_resd_addr -- 控制人英文现居地址
    ,ctrler_birth_dt -- 控制人出生日期
    ,tax_resdnt_idti_cd	 -- 税收居民身份代码	
    ,cert_invalid_dt	 --证件失效日期	
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_op(
            party_id -- 当事人编号
    ,rela_party_id -- 关联当事人编号
    ,ctrler_type_cd -- 控制人类型代码
    ,ctrler_cert_type_cd -- 控制人证件类型代码
    ,ctrler_cert_no -- 控制人证件号码
    ,ctrler_name -- 控制人名称
    ,ctrler_legal_en_last_name -- 控制人法定英文姓氏
    ,ctrler_en_mdl_name -- 控制人英文中间名
    ,ctrler_legal_en_first_name -- 控制人法定英文名字
    ,ctrler_tax_red_cty_cd_comb -- 控制人税收居民国家代码组合
    ,get_stament_flg -- 取得自证声明标志
    ,tax_num -- 纳税人识别号
    ,distr_idtfy_num_cty_cd_comb -- 发放识别号国家代码组合
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,ctrler_birth_city_name -- 控制人出生城市名称
    ,birth_cty_home_and_rg_cd -- 出生国家和地区代码
    ,ctrler_birth_cty_en_name -- 控制人出生国英文名称
    ,ctrler_cn_birth_addr -- 控制人中文出生地址
    ,ctrler_cn_resd_addr -- 控制人中文现居地址
    ,ctrler_en_resd_addr -- 控制人英文现居地址
    ,ctrler_birth_dt -- 控制人出生日期
    ,tax_resdnt_idti_cd	 -- 税收居民身份代码	
    ,cert_invalid_dt	 --证件失效日期	
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.rela_party_id, o.rela_party_id) as rela_party_id -- 关联当事人编号
    ,nvl(n.ctrler_type_cd, o.ctrler_type_cd) as ctrler_type_cd -- 控制人类型代码
    ,nvl(n.ctrler_cert_type_cd, o.ctrler_cert_type_cd) as ctrler_cert_type_cd -- 控制人证件类型代码
    ,nvl(n.ctrler_cert_no, o.ctrler_cert_no) as ctrler_cert_no -- 控制人证件号码
    ,nvl(n.ctrler_name, o.ctrler_name) as ctrler_name -- 控制人名称
    ,nvl(n.ctrler_legal_en_last_name, o.ctrler_legal_en_last_name) as ctrler_legal_en_last_name -- 控制人法定英文姓氏
    ,nvl(n.ctrler_en_mdl_name, o.ctrler_en_mdl_name) as ctrler_en_mdl_name -- 控制人英文中间名
    ,nvl(n.ctrler_legal_en_first_name, o.ctrler_legal_en_first_name) as ctrler_legal_en_first_name -- 控制人法定英文名字
    ,nvl(n.ctrler_tax_red_cty_cd_comb, o.ctrler_tax_red_cty_cd_comb) as ctrler_tax_red_cty_cd_comb -- 控制人税收居民国家代码组合
    ,nvl(n.get_stament_flg, o.get_stament_flg) as get_stament_flg -- 取得自证声明标志
    ,nvl(n.tax_num, o.tax_num) as tax_num -- 纳税人识别号
    ,nvl(n.distr_idtfy_num_cty_cd_comb, o.distr_idtfy_num_cty_cd_comb) as distr_idtfy_num_cty_cd_comb -- 发放识别号国家代码组合
    ,nvl(n.tax_num_null_rs_descb, o.tax_num_null_rs_descb) as tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,nvl(n.ctrler_birth_city_name, o.ctrler_birth_city_name) as ctrler_birth_city_name -- 控制人出生城市名称
    ,nvl(n.birth_cty_home_and_rg_cd, o.birth_cty_home_and_rg_cd) as birth_cty_home_and_rg_cd -- 出生国家和地区代码
    ,nvl(n.ctrler_birth_cty_en_name, o.ctrler_birth_cty_en_name) as ctrler_birth_cty_en_name -- 控制人出生国英文名称
    ,nvl(n.ctrler_cn_birth_addr, o.ctrler_cn_birth_addr) as ctrler_cn_birth_addr -- 控制人中文出生地址
    ,nvl(n.ctrler_cn_resd_addr, o.ctrler_cn_resd_addr) as ctrler_cn_resd_addr -- 控制人中文现居地址
    ,nvl(n.ctrler_en_resd_addr, o.ctrler_en_resd_addr) as ctrler_en_resd_addr -- 控制人英文现居地址
    ,nvl(n.ctrler_birth_dt, o.ctrler_birth_dt) as ctrler_birth_dt -- 控制人出生日期
    ,nvl(n.tax_resdnt_idti_cd, o.tax_resdnt_idti_cd) as tax_resdnt_idti_cd -- 税收居民身份代码
    ,nvl(n.cert_invalid_dt, o.cert_invalid_dt) as cert_invalid_dt -- 证件失效日期
    ,case when
            n.party_id is null
            and n.rela_party_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.rela_party_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.rela_party_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.rela_party_id = n.rela_party_id
where (
        o.party_id is null
        and o.rela_party_id is null
    )
    or (
        n.party_id is null
        and n.rela_party_id is null
    )
    or (
        o.ctrler_type_cd <> n.ctrler_type_cd
        or o.ctrler_cert_type_cd <> n.ctrler_cert_type_cd
        or o.ctrler_cert_no <> n.ctrler_cert_no
        or o.ctrler_name <> n.ctrler_name
        or o.ctrler_legal_en_last_name <> n.ctrler_legal_en_last_name
        or o.ctrler_en_mdl_name <> n.ctrler_en_mdl_name
        or o.ctrler_legal_en_first_name <> n.ctrler_legal_en_first_name
        or o.ctrler_tax_red_cty_cd_comb <> n.ctrler_tax_red_cty_cd_comb
        or o.get_stament_flg <> n.get_stament_flg
        or o.tax_num <> n.tax_num
        or o.distr_idtfy_num_cty_cd_comb <> n.distr_idtfy_num_cty_cd_comb
        or o.tax_num_null_rs_descb <> n.tax_num_null_rs_descb
        or o.ctrler_birth_city_name <> n.ctrler_birth_city_name
        or o.birth_cty_home_and_rg_cd <> n.birth_cty_home_and_rg_cd
        or o.ctrler_birth_cty_en_name <> n.ctrler_birth_cty_en_name
        or o.ctrler_cn_birth_addr <> n.ctrler_cn_birth_addr
        or o.ctrler_cn_resd_addr <> n.ctrler_cn_resd_addr
        or o.ctrler_en_resd_addr <> n.ctrler_en_resd_addr
        or o.ctrler_birth_dt <> n.ctrler_birth_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_cl(
            party_id -- 当事人编号
    ,rela_party_id -- 关联当事人编号
    ,ctrler_type_cd -- 控制人类型代码
    ,ctrler_cert_type_cd -- 控制人证件类型代码
    ,ctrler_cert_no -- 控制人证件号码
    ,ctrler_name -- 控制人名称
    ,ctrler_legal_en_last_name -- 控制人法定英文姓氏
    ,ctrler_en_mdl_name -- 控制人英文中间名
    ,ctrler_legal_en_first_name -- 控制人法定英文名字
    ,ctrler_tax_red_cty_cd_comb -- 控制人税收居民国家代码组合
    ,get_stament_flg -- 取得自证声明标志
    ,tax_num -- 纳税人识别号
    ,distr_idtfy_num_cty_cd_comb -- 发放识别号国家代码组合
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,ctrler_birth_city_name -- 控制人出生城市名称
    ,birth_cty_home_and_rg_cd -- 出生国家和地区代码
    ,ctrler_birth_cty_en_name -- 控制人出生国英文名称
    ,ctrler_cn_birth_addr -- 控制人中文出生地址
    ,ctrler_cn_resd_addr -- 控制人中文现居地址
    ,ctrler_en_resd_addr -- 控制人英文现居地址
    ,ctrler_birth_dt -- 控制人出生日期
    ,tax_resdnt_idti_cd	 -- 税收居民身份代码	
    ,cert_invalid_dt	 --证件失效日期	
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_op(
            party_id -- 当事人编号
    ,rela_party_id -- 关联当事人编号
    ,ctrler_type_cd -- 控制人类型代码
    ,ctrler_cert_type_cd -- 控制人证件类型代码
    ,ctrler_cert_no -- 控制人证件号码
    ,ctrler_name -- 控制人名称
    ,ctrler_legal_en_last_name -- 控制人法定英文姓氏
    ,ctrler_en_mdl_name -- 控制人英文中间名
    ,ctrler_legal_en_first_name -- 控制人法定英文名字
    ,ctrler_tax_red_cty_cd_comb -- 控制人税收居民国家代码组合
    ,get_stament_flg -- 取得自证声明标志
    ,tax_num -- 纳税人识别号
    ,distr_idtfy_num_cty_cd_comb -- 发放识别号国家代码组合
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,ctrler_birth_city_name -- 控制人出生城市名称
    ,birth_cty_home_and_rg_cd -- 出生国家和地区代码
    ,ctrler_birth_cty_en_name -- 控制人出生国英文名称
    ,ctrler_cn_birth_addr -- 控制人中文出生地址
    ,ctrler_cn_resd_addr -- 控制人中文现居地址
    ,ctrler_en_resd_addr -- 控制人英文现居地址
    ,ctrler_birth_dt -- 控制人出生日期
    ,tax_resdnt_idti_cd	 -- 税收居民身份代码	
    ,cert_invalid_dt	 --证件失效日期	
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.rela_party_id -- 关联当事人编号
    ,o.ctrler_type_cd -- 控制人类型代码
    ,o.ctrler_cert_type_cd -- 控制人证件类型代码
    ,o.ctrler_cert_no -- 控制人证件号码
    ,o.ctrler_name -- 控制人名称
    ,o.ctrler_legal_en_last_name -- 控制人法定英文姓氏
    ,o.ctrler_en_mdl_name -- 控制人英文中间名
    ,o.ctrler_legal_en_first_name -- 控制人法定英文名字
    ,o.ctrler_tax_red_cty_cd_comb -- 控制人税收居民国家代码组合
    ,o.get_stament_flg -- 取得自证声明标志
    ,o.tax_num -- 纳税人识别号
    ,o.distr_idtfy_num_cty_cd_comb -- 发放识别号国家代码组合
    ,o.tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,o.ctrler_birth_city_name -- 控制人出生城市名称
    ,o.birth_cty_home_and_rg_cd -- 出生国家和地区代码
    ,o.ctrler_birth_cty_en_name -- 控制人出生国英文名称
    ,o.ctrler_cn_birth_addr -- 控制人中文出生地址
    ,o.ctrler_cn_resd_addr -- 控制人中文现居地址
    ,o.ctrler_en_resd_addr -- 控制人英文现居地址
    ,o.ctrler_birth_dt -- 控制人出生日期
    ,o.tax_resdnt_idti_cd	 -- 税收居民身份代码	
    ,o.cert_invalid_dt	 --证件失效日期	
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_bk o
    left join ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.rela_party_id = n.rela_party_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_cl d
        on
            o.party_id = d.party_id
            and o.rela_party_id = d.rela_party_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_corp_ctrler_tax_h;
alter table ${iml_schema}.pty_corp_ctrler_tax_h truncate partition for ('eifsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.pty_corp_ctrler_tax_h exchange subpartition p_eifsf1_19000101 with table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_cl;
alter table ${iml_schema}.pty_corp_ctrler_tax_h exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_corp_ctrler_tax_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_op purge;
drop table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_corp_ctrler_tax_h_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_corp_ctrler_tax_h', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
