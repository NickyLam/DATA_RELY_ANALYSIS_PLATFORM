/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_role_rela_h_eifsf1
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
alter table ${iml_schema}.pty_role_rela_h add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_role_rela_h_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_role_rela_h partition for ('eifsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_role_rela_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_role_rela_h_eifsf1_op purge;
drop table ${iml_schema}.pty_role_rela_h_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_role_rela_h_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,rela_party_id -- 关联当事人编号
    ,party_role_type_id -- 当事人角色类型编号
    ,rela_party_role_type_id -- 关联当事人角色类型编号
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,share_ratio -- 持股比例
    ,shard_id -- 股东编号
    ,shard_type_cd -- 股东类型代码
    ,contri_amt -- 出资金额
    ,ctrler_idf_cd -- 控制人标识代码
    ,ctrler_red_idti_type_cd -- 控制人税收居民身份类型代码
    ,ctrler_birth_dt -- 控制人出生日期
    ,ctrler_cn_birth_addr -- 控制人中文出生地址
    ,ctrler_cn_resd_addr -- 控制人中文现居地址
    ,ctrler_tax_red_cty -- 控制人税收居民国家
    ,ctrler_tax_num -- 控制人纳税人识别号
    ,ctrler_tax_null_rs_descb -- 控制人纳税人识别号空值原因描述
    ,stament_flg -- 取得自证声明标志
    ,ctrler_type_cd -- 控制人类型代码
    ,ctrler_name -- 控制人姓名
    ,ctrler_en_birth_addr -- 控制人英文出生地址
    ,ctrler_en_resd_addr -- 控制人英文现居地址
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_role_rela_h partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_role_rela_h_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_role_rela_h partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_role_rela_h_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_role_rela_h partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_party_relationship-
insert into ${iml_schema}.pty_role_rela_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,rela_party_id -- 关联当事人编号
    ,party_role_type_id -- 当事人角色类型编号
    ,rela_party_role_type_id -- 关联当事人角色类型编号
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,share_ratio -- 持股比例
    ,shard_id -- 股东编号
    ,shard_type_cd -- 股东类型代码
    ,contri_amt -- 出资金额
    ,ctrler_idf_cd -- 控制人标识代码
    ,ctrler_red_idti_type_cd -- 控制人税收居民身份类型代码
    ,ctrler_birth_dt -- 控制人出生日期
    ,ctrler_cn_birth_addr -- 控制人中文出生地址
    ,ctrler_cn_resd_addr -- 控制人中文现居地址
    ,ctrler_tax_red_cty -- 控制人税收居民国家
    ,ctrler_tax_num -- 控制人纳税人识别号
    ,ctrler_tax_null_rs_descb -- 控制人纳税人识别号空值原因描述
    ,stament_flg -- 取得自证声明标志
    ,ctrler_type_cd -- 控制人类型代码
    ,ctrler_name -- 控制人姓名
    ,ctrler_en_birth_addr -- 控制人英文出生地址
    ,ctrler_en_resd_addr -- 控制人英文现居地址
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p1.PARTY_ID_FROM -- 当事人编号
    ,'9999' -- 法人编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||p1.PARTY_RELATIONSHIP_TYPE_ID END -- 当事人关系类型代码
    ,p1.PARTY_ID_TO -- 关联当事人编号
    ,P1.ROLE_TYPE_ID_FROM -- 当事人角色类型编号
    ,P1.ROLE_TYPE_ID_TO -- 关联当事人角色类型编号
    ,P1.FROM_DATE -- 生效时间
    ,CASE WHEN TO_CHAR(P1.THRU_DATE,'YYYYMMDD') = '00010101' THEN ${iml_schema}.dateformat_max(NULL) ELSE P1.THRU_DATE END  -- 失效时间
    ,to_number(nvl(trim(p1.SHAREHOLDING_RATIO),'0')) -- 持股比例
    ,P1.SHARE_HOLDER_ID -- 股东编号
    ,NVL(TRIM(P1.SHARETP),'-') -- 股东类型代码
    ,P1.SHARE_HOLDER_AMOUNT -- 出资金额
    ,NVL(TRIM(P1.WHETHER_CONTROLLER),'-') -- 控制人标识代码
    ,NVL(TRIM(P1.CONTROLLER_TAX_RESIDENT),'-') -- 控制人税收居民身份类型代码
    ,${iml_schema}.dateformat_min(p1.CONTROLLER_BIRTH_DATE) -- 控制人出生日期
    ,P1.CONTROLLER_BIRTH_PLACE -- 控制人中文出生地址
    ,P1.CONTROLLER_ADDRESS -- 控制人中文现居地址
    ,P1.CONTROLLER_TAX_AREA -- 控制人税收居民国家
    ,P1.CONTROLLER_TAX_NUMBER -- 控制人纳税人识别号
    ,P1.CONTROLLER_TAX_NULL_REASON -- 控制人纳税人识别号空值原因描述
    ,NVL(TRIM(P1.CONTROLLER_TAX_STATEMENT),'-') -- 取得自证声明标志
    ,NVL(TRIM(P1.CONTROLLER_TYPE),'-') -- 控制人类型代码
    ,P1.CONTROLLER_ENGLISH_NAME -- 控制人姓名
    ,P1.CONTROLLER_BIRTH_PLACE_EN -- 控制人英文出生地址
    ,P1.CONTROLLER_ADDRESS_EN -- 控制人英文现居地址
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_party_relationship' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_party_relationship p1
    left join ${iml_schema}.ref_pub_cd_map r1 on p1.PARTY_RELATIONSHIP_TYPE_ID = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'EIFS'
        AND R1.SRC_TAB_EN_NAME= 'EIFS_PARTY_RELATIONSHIP'
        AND R1.SRC_FIELD_EN_NAME= 'PARTY_RELATIONSHIP_TYPE_ID'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_ROLE_RELA_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PARTY_RELA_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_role_rela_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,rela_party_id -- 关联当事人编号
    ,party_role_type_id -- 当事人角色类型编号
    ,rela_party_role_type_id -- 关联当事人角色类型编号
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,share_ratio -- 持股比例
    ,shard_id -- 股东编号
    ,shard_type_cd -- 股东类型代码
    ,contri_amt -- 出资金额
    ,ctrler_idf_cd -- 控制人标识代码
    ,ctrler_red_idti_type_cd -- 控制人税收居民身份类型代码
    ,ctrler_birth_dt -- 控制人出生日期
    ,ctrler_cn_birth_addr -- 控制人中文出生地址
    ,ctrler_cn_resd_addr -- 控制人中文现居地址
    ,ctrler_tax_red_cty -- 控制人税收居民国家
    ,ctrler_tax_num -- 控制人纳税人识别号
    ,ctrler_tax_null_rs_descb -- 控制人纳税人识别号空值原因描述
    ,stament_flg -- 取得自证声明标志
    ,ctrler_type_cd -- 控制人类型代码
    ,ctrler_name -- 控制人姓名
    ,ctrler_en_birth_addr -- 控制人英文出生地址
    ,ctrler_en_resd_addr -- 控制人英文现居地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_role_rela_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,rela_party_id -- 关联当事人编号
    ,party_role_type_id -- 当事人角色类型编号
    ,rela_party_role_type_id -- 关联当事人角色类型编号
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,share_ratio -- 持股比例
    ,shard_id -- 股东编号
    ,shard_type_cd -- 股东类型代码
    ,contri_amt -- 出资金额
    ,ctrler_idf_cd -- 控制人标识代码
    ,ctrler_red_idti_type_cd -- 控制人税收居民身份类型代码
    ,ctrler_birth_dt -- 控制人出生日期
    ,ctrler_cn_birth_addr -- 控制人中文出生地址
    ,ctrler_cn_resd_addr -- 控制人中文现居地址
    ,ctrler_tax_red_cty -- 控制人税收居民国家
    ,ctrler_tax_num -- 控制人纳税人识别号
    ,ctrler_tax_null_rs_descb -- 控制人纳税人识别号空值原因描述
    ,stament_flg -- 取得自证声明标志
    ,ctrler_type_cd -- 控制人类型代码
    ,ctrler_name -- 控制人姓名
    ,ctrler_en_birth_addr -- 控制人英文出生地址
    ,ctrler_en_resd_addr -- 控制人英文现居地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.party_rela_type_cd, o.party_rela_type_cd) as party_rela_type_cd -- 当事人关系类型代码
    ,nvl(n.rela_party_id, o.rela_party_id) as rela_party_id -- 关联当事人编号
    ,nvl(n.party_role_type_id, o.party_role_type_id) as party_role_type_id -- 当事人角色类型编号
    ,nvl(n.rela_party_role_type_id, o.rela_party_role_type_id) as rela_party_role_type_id -- 关联当事人角色类型编号
    ,nvl(n.effect_tm, o.effect_tm) as effect_tm -- 生效时间
    ,nvl(n.invalid_tm, o.invalid_tm) as invalid_tm -- 失效时间
    ,nvl(n.share_ratio, o.share_ratio) as share_ratio -- 持股比例
    ,nvl(n.shard_id, o.shard_id) as shard_id -- 股东编号
    ,nvl(n.shard_type_cd, o.shard_type_cd) as shard_type_cd -- 股东类型代码
    ,nvl(n.contri_amt, o.contri_amt) as contri_amt -- 出资金额
    ,nvl(n.ctrler_idf_cd, o.ctrler_idf_cd) as ctrler_idf_cd -- 控制人标识代码
    ,nvl(n.ctrler_red_idti_type_cd, o.ctrler_red_idti_type_cd) as ctrler_red_idti_type_cd -- 控制人税收居民身份类型代码
    ,nvl(n.ctrler_birth_dt, o.ctrler_birth_dt) as ctrler_birth_dt -- 控制人出生日期
    ,nvl(n.ctrler_cn_birth_addr, o.ctrler_cn_birth_addr) as ctrler_cn_birth_addr -- 控制人中文出生地址
    ,nvl(n.ctrler_cn_resd_addr, o.ctrler_cn_resd_addr) as ctrler_cn_resd_addr -- 控制人中文现居地址
    ,nvl(n.ctrler_tax_red_cty, o.ctrler_tax_red_cty) as ctrler_tax_red_cty -- 控制人税收居民国家
    ,nvl(n.ctrler_tax_num, o.ctrler_tax_num) as ctrler_tax_num -- 控制人纳税人识别号
    ,nvl(n.ctrler_tax_null_rs_descb, o.ctrler_tax_null_rs_descb) as ctrler_tax_null_rs_descb -- 控制人纳税人识别号空值原因描述
    ,nvl(n.stament_flg, o.stament_flg) as stament_flg -- 取得自证声明标志
    ,nvl(n.ctrler_type_cd, o.ctrler_type_cd) as ctrler_type_cd -- 控制人类型代码
    ,nvl(n.ctrler_name, o.ctrler_name) as ctrler_name -- 控制人姓名
    ,nvl(n.ctrler_en_birth_addr, o.ctrler_en_birth_addr) as ctrler_en_birth_addr -- 控制人英文出生地址
    ,nvl(n.ctrler_en_resd_addr, o.ctrler_en_resd_addr) as ctrler_en_resd_addr -- 控制人英文现居地址
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.rela_party_id is null
            and n.party_role_type_id is null
            and n.rela_party_role_type_id is null
            and n.effect_tm is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.rela_party_id is null
            and n.party_role_type_id is null
            and n.rela_party_role_type_id is null
            and n.effect_tm is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.rela_party_id is null
            and n.party_role_type_id is null
            and n.rela_party_role_type_id is null
            and n.effect_tm is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_role_rela_h_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_role_rela_h_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.rela_party_id = n.rela_party_id
            and o.party_role_type_id = n.party_role_type_id
            and o.rela_party_role_type_id = n.rela_party_role_type_id
            and o.effect_tm = n.effect_tm
where (
        o.party_id is null
        and o.lp_id is null
        and o.rela_party_id is null
        and o.party_role_type_id is null
        and o.rela_party_role_type_id is null
        and o.effect_tm is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.rela_party_id is null
        and n.party_role_type_id is null
        and n.rela_party_role_type_id is null
        and n.effect_tm is null
    )
    or (
        o.party_rela_type_cd <> n.party_rela_type_cd
        or o.invalid_tm <> n.invalid_tm
        or o.share_ratio <> n.share_ratio
        or o.shard_id <> n.shard_id
        or o.shard_type_cd <> n.shard_type_cd
        or o.contri_amt <> n.contri_amt
        or o.ctrler_idf_cd <> n.ctrler_idf_cd
        or o.ctrler_red_idti_type_cd <> n.ctrler_red_idti_type_cd
        or o.ctrler_birth_dt <> n.ctrler_birth_dt
        or o.ctrler_cn_birth_addr <> n.ctrler_cn_birth_addr
        or o.ctrler_cn_resd_addr <> n.ctrler_cn_resd_addr
        or o.ctrler_tax_red_cty <> n.ctrler_tax_red_cty
        or o.ctrler_tax_num <> n.ctrler_tax_num
        or o.ctrler_tax_null_rs_descb <> n.ctrler_tax_null_rs_descb
        or o.stament_flg <> n.stament_flg
        or o.ctrler_type_cd <> n.ctrler_type_cd
        or o.ctrler_name <> n.ctrler_name
        or o.ctrler_en_birth_addr <> n.ctrler_en_birth_addr
        or o.ctrler_en_resd_addr <> n.ctrler_en_resd_addr
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_role_rela_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,rela_party_id -- 关联当事人编号
    ,party_role_type_id -- 当事人角色类型编号
    ,rela_party_role_type_id -- 关联当事人角色类型编号
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,share_ratio -- 持股比例
    ,shard_id -- 股东编号
    ,shard_type_cd -- 股东类型代码
    ,contri_amt -- 出资金额
    ,ctrler_idf_cd -- 控制人标识代码
    ,ctrler_red_idti_type_cd -- 控制人税收居民身份类型代码
    ,ctrler_birth_dt -- 控制人出生日期
    ,ctrler_cn_birth_addr -- 控制人中文出生地址
    ,ctrler_cn_resd_addr -- 控制人中文现居地址
    ,ctrler_tax_red_cty -- 控制人税收居民国家
    ,ctrler_tax_num -- 控制人纳税人识别号
    ,ctrler_tax_null_rs_descb -- 控制人纳税人识别号空值原因描述
    ,stament_flg -- 取得自证声明标志
    ,ctrler_type_cd -- 控制人类型代码
    ,ctrler_name -- 控制人姓名
    ,ctrler_en_birth_addr -- 控制人英文出生地址
    ,ctrler_en_resd_addr -- 控制人英文现居地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_role_rela_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,party_rela_type_cd -- 当事人关系类型代码
    ,rela_party_id -- 关联当事人编号
    ,party_role_type_id -- 当事人角色类型编号
    ,rela_party_role_type_id -- 关联当事人角色类型编号
    ,effect_tm -- 生效时间
    ,invalid_tm -- 失效时间
    ,share_ratio -- 持股比例
    ,shard_id -- 股东编号
    ,shard_type_cd -- 股东类型代码
    ,contri_amt -- 出资金额
    ,ctrler_idf_cd -- 控制人标识代码
    ,ctrler_red_idti_type_cd -- 控制人税收居民身份类型代码
    ,ctrler_birth_dt -- 控制人出生日期
    ,ctrler_cn_birth_addr -- 控制人中文出生地址
    ,ctrler_cn_resd_addr -- 控制人中文现居地址
    ,ctrler_tax_red_cty -- 控制人税收居民国家
    ,ctrler_tax_num -- 控制人纳税人识别号
    ,ctrler_tax_null_rs_descb -- 控制人纳税人识别号空值原因描述
    ,stament_flg -- 取得自证声明标志
    ,ctrler_type_cd -- 控制人类型代码
    ,ctrler_name -- 控制人姓名
    ,ctrler_en_birth_addr -- 控制人英文出生地址
    ,ctrler_en_resd_addr -- 控制人英文现居地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.party_rela_type_cd -- 当事人关系类型代码
    ,o.rela_party_id -- 关联当事人编号
    ,o.party_role_type_id -- 当事人角色类型编号
    ,o.rela_party_role_type_id -- 关联当事人角色类型编号
    ,o.effect_tm -- 生效时间
    ,o.invalid_tm -- 失效时间
    ,o.share_ratio -- 持股比例
    ,o.shard_id -- 股东编号
    ,o.shard_type_cd -- 股东类型代码
    ,o.contri_amt -- 出资金额
    ,o.ctrler_idf_cd -- 控制人标识代码
    ,o.ctrler_red_idti_type_cd -- 控制人税收居民身份类型代码
    ,o.ctrler_birth_dt -- 控制人出生日期
    ,o.ctrler_cn_birth_addr -- 控制人中文出生地址
    ,o.ctrler_cn_resd_addr -- 控制人中文现居地址
    ,o.ctrler_tax_red_cty -- 控制人税收居民国家
    ,o.ctrler_tax_num -- 控制人纳税人识别号
    ,o.ctrler_tax_null_rs_descb -- 控制人纳税人识别号空值原因描述
    ,o.stament_flg -- 取得自证声明标志
    ,o.ctrler_type_cd -- 控制人类型代码
    ,o.ctrler_name -- 控制人姓名
    ,o.ctrler_en_birth_addr -- 控制人英文出生地址
    ,o.ctrler_en_resd_addr -- 控制人英文现居地址
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_role_rela_h_eifsf1_bk o
    left join ${iml_schema}.pty_role_rela_h_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.rela_party_id = n.rela_party_id
            and o.party_role_type_id = n.party_role_type_id
            and o.rela_party_role_type_id = n.rela_party_role_type_id
            and o.effect_tm = n.effect_tm
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_role_rela_h_eifsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.rela_party_id = d.rela_party_id
            and o.party_role_type_id = d.party_role_type_id
            and o.rela_party_role_type_id = d.rela_party_role_type_id
            and o.effect_tm = d.effect_tm
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_role_rela_h;
alter table ${iml_schema}.pty_role_rela_h truncate partition for ('eifsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.pty_role_rela_h exchange subpartition p_eifsf1_19000101 with table ${iml_schema}.pty_role_rela_h_eifsf1_cl;
alter table ${iml_schema}.pty_role_rela_h exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_role_rela_h_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_role_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_role_rela_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_role_rela_h_eifsf1_op purge;
drop table ${iml_schema}.pty_role_rela_h_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_role_rela_h_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_role_rela_h', partname => 'p_eifsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
