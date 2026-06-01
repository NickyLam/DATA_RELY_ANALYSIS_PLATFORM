/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_jh_mcht_inf
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.mrms_tbl_jh_mcht_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_jh_mcht_inf
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_jh_mcht_inf_op purge;
drop table ${iol_schema}.mrms_tbl_jh_mcht_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_jh_mcht_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_jh_mcht_inf where 0=1;

create table ${iol_schema}.mrms_tbl_jh_mcht_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_jh_mcht_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_jh_mcht_inf_cl(
            agent_cd -- 代理编号
            ,mcht_no -- 商户号
            ,mcht_nm -- 商户名称
            ,mcht_cn_abbr -- 中文名称简写
            ,spell_name -- 商户拼音缩写
            ,eng_name -- 商户英文名称
            ,mcht_en_abbr -- 商户英文名称缩写
            ,license_type -- 证件类型
            ,licence_no -- 证件编号号码
            ,licence_end_date -- 证件有效期
            ,mcht_lvl -- 商户级别
            ,contact -- 联系人姓名
            ,contact_class -- 联系人类型
            ,comm_email -- 联系人电子邮箱
            ,comm_mobil -- 客户电话
            ,comm_tel -- 联系人电话
            ,addr -- 联系人地址
            ,manager -- 法人姓名
            ,artif_certif_tp -- 法人证件类型
            ,identity_no -- 联系人证件号码
            ,manager_tel -- 法人联系电话
            ,post_code -- 邮编
            ,fax -- 传真
            ,area_no -- 区域代码
            ,mcht_eng_city_name -- 商户所在城市
            ,mcht_key -- 商户密钥
            ,oper_no -- 客户经理工号
            ,oper_nm -- 客户经理姓名
            ,mcht_status -- 商户状态
            ,risl_lvl -- 商户风险级别
            ,reg_addr -- 注册地址
            ,bank_licence_no -- 机构代码证号码
            ,bus_type -- 营业性质
            ,fax_no -- 税务登记证号码
            ,bus_amt -- 注册资金
            ,mcht_cre_lvl -- 企业资质等级
            ,apply_date -- 申请日期
            ,enable_date -- 启用日期
            ,pre_aud_nm -- 初审人
            ,confirm_nm -- 批准人
            ,protocal_id -- 协议编号
            ,sign_inst_id -- 签约机构代码(银联分配机构号)
            ,net_nm -- 隶属网点代码
            ,agr_br -- 签约网点
            ,net_tel -- 网点电话
            ,prol_date -- 签约日期
            ,prol_tlr -- 签约柜员
            ,close_date -- 撤消签约日期
            ,close_tlr -- 撤消签约柜员
            ,main_tlr -- 维护柜员
            ,check_tlr -- 复核柜员
            ,acq_inst_id -- 商户所属机构代码
            ,acq_bk_name -- 收单行名称
            ,bank_no -- 分行号
            ,mcht_secret -- 商户秘钥
            ,reserved -- 保留
            ,upd_opr_id -- 修改记录操作员
            ,crt_opr_id -- 创建记录操作员
            ,rec_upd_ts -- 记录修改时间
            ,rec_crt_ts -- 记录创建时间
            ,province_code -- 省份编码
            ,city_code -- 城市编码
            ,district_code -- 区域编码
            ,legal_person_id_card -- 法人证件号码
            ,flow_bank_no -- 流程银行流水号
            ,flow_bank_status -- 流程银行审批结果,0-初始状态1-审批通过2-审批不通过
            ,flow_bank_reserved -- 流程银行审批描述
            ,h5_flow_flag -- H5标识 ，1-H5渠道
            ,risk_statu -- 
            ,mq_statu -- 
            ,risk_describe -- 
            ,risk_flag -- 
            ,out_mcht_no -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_jh_mcht_inf_op(
            agent_cd -- 代理编号
            ,mcht_no -- 商户号
            ,mcht_nm -- 商户名称
            ,mcht_cn_abbr -- 中文名称简写
            ,spell_name -- 商户拼音缩写
            ,eng_name -- 商户英文名称
            ,mcht_en_abbr -- 商户英文名称缩写
            ,license_type -- 证件类型
            ,licence_no -- 证件编号号码
            ,licence_end_date -- 证件有效期
            ,mcht_lvl -- 商户级别
            ,contact -- 联系人姓名
            ,contact_class -- 联系人类型
            ,comm_email -- 联系人电子邮箱
            ,comm_mobil -- 客户电话
            ,comm_tel -- 联系人电话
            ,addr -- 联系人地址
            ,manager -- 法人姓名
            ,artif_certif_tp -- 法人证件类型
            ,identity_no -- 联系人证件号码
            ,manager_tel -- 法人联系电话
            ,post_code -- 邮编
            ,fax -- 传真
            ,area_no -- 区域代码
            ,mcht_eng_city_name -- 商户所在城市
            ,mcht_key -- 商户密钥
            ,oper_no -- 客户经理工号
            ,oper_nm -- 客户经理姓名
            ,mcht_status -- 商户状态
            ,risl_lvl -- 商户风险级别
            ,reg_addr -- 注册地址
            ,bank_licence_no -- 机构代码证号码
            ,bus_type -- 营业性质
            ,fax_no -- 税务登记证号码
            ,bus_amt -- 注册资金
            ,mcht_cre_lvl -- 企业资质等级
            ,apply_date -- 申请日期
            ,enable_date -- 启用日期
            ,pre_aud_nm -- 初审人
            ,confirm_nm -- 批准人
            ,protocal_id -- 协议编号
            ,sign_inst_id -- 签约机构代码(银联分配机构号)
            ,net_nm -- 隶属网点代码
            ,agr_br -- 签约网点
            ,net_tel -- 网点电话
            ,prol_date -- 签约日期
            ,prol_tlr -- 签约柜员
            ,close_date -- 撤消签约日期
            ,close_tlr -- 撤消签约柜员
            ,main_tlr -- 维护柜员
            ,check_tlr -- 复核柜员
            ,acq_inst_id -- 商户所属机构代码
            ,acq_bk_name -- 收单行名称
            ,bank_no -- 分行号
            ,mcht_secret -- 商户秘钥
            ,reserved -- 保留
            ,upd_opr_id -- 修改记录操作员
            ,crt_opr_id -- 创建记录操作员
            ,rec_upd_ts -- 记录修改时间
            ,rec_crt_ts -- 记录创建时间
            ,province_code -- 省份编码
            ,city_code -- 城市编码
            ,district_code -- 区域编码
            ,legal_person_id_card -- 法人证件号码
            ,flow_bank_no -- 流程银行流水号
            ,flow_bank_status -- 流程银行审批结果,0-初始状态1-审批通过2-审批不通过
            ,flow_bank_reserved -- 流程银行审批描述
            ,h5_flow_flag -- H5标识 ，1-H5渠道
            ,risk_statu -- 
            ,mq_statu -- 
            ,risk_describe -- 
            ,risk_flag -- 
            ,out_mcht_no -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agent_cd, o.agent_cd) as agent_cd -- 代理编号
    ,nvl(n.mcht_no, o.mcht_no) as mcht_no -- 商户号
    ,nvl(n.mcht_nm, o.mcht_nm) as mcht_nm -- 商户名称
    ,nvl(n.mcht_cn_abbr, o.mcht_cn_abbr) as mcht_cn_abbr -- 中文名称简写
    ,nvl(n.spell_name, o.spell_name) as spell_name -- 商户拼音缩写
    ,nvl(n.eng_name, o.eng_name) as eng_name -- 商户英文名称
    ,nvl(n.mcht_en_abbr, o.mcht_en_abbr) as mcht_en_abbr -- 商户英文名称缩写
    ,nvl(n.license_type, o.license_type) as license_type -- 证件类型
    ,nvl(n.licence_no, o.licence_no) as licence_no -- 证件编号号码
    ,nvl(n.licence_end_date, o.licence_end_date) as licence_end_date -- 证件有效期
    ,nvl(n.mcht_lvl, o.mcht_lvl) as mcht_lvl -- 商户级别
    ,nvl(n.contact, o.contact) as contact -- 联系人姓名
    ,nvl(n.contact_class, o.contact_class) as contact_class -- 联系人类型
    ,nvl(n.comm_email, o.comm_email) as comm_email -- 联系人电子邮箱
    ,nvl(n.comm_mobil, o.comm_mobil) as comm_mobil -- 客户电话
    ,nvl(n.comm_tel, o.comm_tel) as comm_tel -- 联系人电话
    ,nvl(n.addr, o.addr) as addr -- 联系人地址
    ,nvl(n.manager, o.manager) as manager -- 法人姓名
    ,nvl(n.artif_certif_tp, o.artif_certif_tp) as artif_certif_tp -- 法人证件类型
    ,nvl(n.identity_no, o.identity_no) as identity_no -- 联系人证件号码
    ,nvl(n.manager_tel, o.manager_tel) as manager_tel -- 法人联系电话
    ,nvl(n.post_code, o.post_code) as post_code -- 邮编
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.area_no, o.area_no) as area_no -- 区域代码
    ,nvl(n.mcht_eng_city_name, o.mcht_eng_city_name) as mcht_eng_city_name -- 商户所在城市
    ,nvl(n.mcht_key, o.mcht_key) as mcht_key -- 商户密钥
    ,nvl(n.oper_no, o.oper_no) as oper_no -- 客户经理工号
    ,nvl(n.oper_nm, o.oper_nm) as oper_nm -- 客户经理姓名
    ,nvl(n.mcht_status, o.mcht_status) as mcht_status -- 商户状态
    ,nvl(n.risl_lvl, o.risl_lvl) as risl_lvl -- 商户风险级别
    ,nvl(n.reg_addr, o.reg_addr) as reg_addr -- 注册地址
    ,nvl(n.bank_licence_no, o.bank_licence_no) as bank_licence_no -- 机构代码证号码
    ,nvl(n.bus_type, o.bus_type) as bus_type -- 营业性质
    ,nvl(n.fax_no, o.fax_no) as fax_no -- 税务登记证号码
    ,nvl(n.bus_amt, o.bus_amt) as bus_amt -- 注册资金
    ,nvl(n.mcht_cre_lvl, o.mcht_cre_lvl) as mcht_cre_lvl -- 企业资质等级
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 申请日期
    ,nvl(n.enable_date, o.enable_date) as enable_date -- 启用日期
    ,nvl(n.pre_aud_nm, o.pre_aud_nm) as pre_aud_nm -- 初审人
    ,nvl(n.confirm_nm, o.confirm_nm) as confirm_nm -- 批准人
    ,nvl(n.protocal_id, o.protocal_id) as protocal_id -- 协议编号
    ,nvl(n.sign_inst_id, o.sign_inst_id) as sign_inst_id -- 签约机构代码(银联分配机构号)
    ,nvl(n.net_nm, o.net_nm) as net_nm -- 隶属网点代码
    ,nvl(n.agr_br, o.agr_br) as agr_br -- 签约网点
    ,nvl(n.net_tel, o.net_tel) as net_tel -- 网点电话
    ,nvl(n.prol_date, o.prol_date) as prol_date -- 签约日期
    ,nvl(n.prol_tlr, o.prol_tlr) as prol_tlr -- 签约柜员
    ,nvl(n.close_date, o.close_date) as close_date -- 撤消签约日期
    ,nvl(n.close_tlr, o.close_tlr) as close_tlr -- 撤消签约柜员
    ,nvl(n.main_tlr, o.main_tlr) as main_tlr -- 维护柜员
    ,nvl(n.check_tlr, o.check_tlr) as check_tlr -- 复核柜员
    ,nvl(n.acq_inst_id, o.acq_inst_id) as acq_inst_id -- 商户所属机构代码
    ,nvl(n.acq_bk_name, o.acq_bk_name) as acq_bk_name -- 收单行名称
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 分行号
    ,nvl(n.mcht_secret, o.mcht_secret) as mcht_secret -- 商户秘钥
    ,nvl(n.reserved, o.reserved) as reserved -- 保留
    ,nvl(n.upd_opr_id, o.upd_opr_id) as upd_opr_id -- 修改记录操作员
    ,nvl(n.crt_opr_id, o.crt_opr_id) as crt_opr_id -- 创建记录操作员
    ,nvl(n.rec_upd_ts, o.rec_upd_ts) as rec_upd_ts -- 记录修改时间
    ,nvl(n.rec_crt_ts, o.rec_crt_ts) as rec_crt_ts -- 记录创建时间
    ,nvl(n.province_code, o.province_code) as province_code -- 省份编码
    ,nvl(n.city_code, o.city_code) as city_code -- 城市编码
    ,nvl(n.district_code, o.district_code) as district_code -- 区域编码
    ,nvl(n.legal_person_id_card, o.legal_person_id_card) as legal_person_id_card -- 法人证件号码
    ,nvl(n.flow_bank_no, o.flow_bank_no) as flow_bank_no -- 流程银行流水号
    ,nvl(n.flow_bank_status, o.flow_bank_status) as flow_bank_status -- 流程银行审批结果,0-初始状态1-审批通过2-审批不通过
    ,nvl(n.flow_bank_reserved, o.flow_bank_reserved) as flow_bank_reserved -- 流程银行审批描述
    ,nvl(n.h5_flow_flag, o.h5_flow_flag) as h5_flow_flag -- H5标识 ，1-H5渠道
    ,nvl(n.risk_statu, o.risk_statu) as risk_statu -- 
    ,nvl(n.mq_statu, o.mq_statu) as mq_statu -- 
    ,nvl(n.risk_describe, o.risk_describe) as risk_describe -- 
    ,nvl(n.risk_flag, o.risk_flag) as risk_flag -- 
    ,nvl(n.out_mcht_no, o.out_mcht_no) as out_mcht_no -- 
    ,case when
            n.mcht_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mcht_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mcht_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_jh_mcht_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_jh_mcht_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mcht_no = n.mcht_no
where (
        o.mcht_no is null
    )
    or (
        n.mcht_no is null
    )
    or (
        o.agent_cd <> n.agent_cd
        or o.mcht_nm <> n.mcht_nm
        or o.mcht_cn_abbr <> n.mcht_cn_abbr
        or o.spell_name <> n.spell_name
        or o.eng_name <> n.eng_name
        or o.mcht_en_abbr <> n.mcht_en_abbr
        or o.license_type <> n.license_type
        or o.licence_no <> n.licence_no
        or o.licence_end_date <> n.licence_end_date
        or o.mcht_lvl <> n.mcht_lvl
        or o.contact <> n.contact
        or o.contact_class <> n.contact_class
        or o.comm_email <> n.comm_email
        or o.comm_mobil <> n.comm_mobil
        or o.comm_tel <> n.comm_tel
        or o.addr <> n.addr
        or o.manager <> n.manager
        or o.artif_certif_tp <> n.artif_certif_tp
        or o.identity_no <> n.identity_no
        or o.manager_tel <> n.manager_tel
        or o.post_code <> n.post_code
        or o.fax <> n.fax
        or o.area_no <> n.area_no
        or o.mcht_eng_city_name <> n.mcht_eng_city_name
        or o.mcht_key <> n.mcht_key
        or o.oper_no <> n.oper_no
        or o.oper_nm <> n.oper_nm
        or o.mcht_status <> n.mcht_status
        or o.risl_lvl <> n.risl_lvl
        or o.reg_addr <> n.reg_addr
        or o.bank_licence_no <> n.bank_licence_no
        or o.bus_type <> n.bus_type
        or o.fax_no <> n.fax_no
        or o.bus_amt <> n.bus_amt
        or o.mcht_cre_lvl <> n.mcht_cre_lvl
        or o.apply_date <> n.apply_date
        or o.enable_date <> n.enable_date
        or o.pre_aud_nm <> n.pre_aud_nm
        or o.confirm_nm <> n.confirm_nm
        or o.protocal_id <> n.protocal_id
        or o.sign_inst_id <> n.sign_inst_id
        or o.net_nm <> n.net_nm
        or o.agr_br <> n.agr_br
        or o.net_tel <> n.net_tel
        or o.prol_date <> n.prol_date
        or o.prol_tlr <> n.prol_tlr
        or o.close_date <> n.close_date
        or o.close_tlr <> n.close_tlr
        or o.main_tlr <> n.main_tlr
        or o.check_tlr <> n.check_tlr
        or o.acq_inst_id <> n.acq_inst_id
        or o.acq_bk_name <> n.acq_bk_name
        or o.bank_no <> n.bank_no
        or o.mcht_secret <> n.mcht_secret
        or o.reserved <> n.reserved
        or o.upd_opr_id <> n.upd_opr_id
        or o.crt_opr_id <> n.crt_opr_id
        or o.rec_upd_ts <> n.rec_upd_ts
        or o.rec_crt_ts <> n.rec_crt_ts
        or o.province_code <> n.province_code
        or o.city_code <> n.city_code
        or o.district_code <> n.district_code
        or o.legal_person_id_card <> n.legal_person_id_card
        or o.flow_bank_no <> n.flow_bank_no
        or o.flow_bank_status <> n.flow_bank_status
        or o.flow_bank_reserved <> n.flow_bank_reserved
        or o.h5_flow_flag <> n.h5_flow_flag
        or o.risk_statu <> n.risk_statu
        or o.mq_statu <> n.mq_statu
        or o.risk_describe <> n.risk_describe
        or o.risk_flag <> n.risk_flag
        or o.out_mcht_no <> n.out_mcht_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_jh_mcht_inf_cl(
            agent_cd -- 代理编号
            ,mcht_no -- 商户号
            ,mcht_nm -- 商户名称
            ,mcht_cn_abbr -- 中文名称简写
            ,spell_name -- 商户拼音缩写
            ,eng_name -- 商户英文名称
            ,mcht_en_abbr -- 商户英文名称缩写
            ,license_type -- 证件类型
            ,licence_no -- 证件编号号码
            ,licence_end_date -- 证件有效期
            ,mcht_lvl -- 商户级别
            ,contact -- 联系人姓名
            ,contact_class -- 联系人类型
            ,comm_email -- 联系人电子邮箱
            ,comm_mobil -- 客户电话
            ,comm_tel -- 联系人电话
            ,addr -- 联系人地址
            ,manager -- 法人姓名
            ,artif_certif_tp -- 法人证件类型
            ,identity_no -- 联系人证件号码
            ,manager_tel -- 法人联系电话
            ,post_code -- 邮编
            ,fax -- 传真
            ,area_no -- 区域代码
            ,mcht_eng_city_name -- 商户所在城市
            ,mcht_key -- 商户密钥
            ,oper_no -- 客户经理工号
            ,oper_nm -- 客户经理姓名
            ,mcht_status -- 商户状态
            ,risl_lvl -- 商户风险级别
            ,reg_addr -- 注册地址
            ,bank_licence_no -- 机构代码证号码
            ,bus_type -- 营业性质
            ,fax_no -- 税务登记证号码
            ,bus_amt -- 注册资金
            ,mcht_cre_lvl -- 企业资质等级
            ,apply_date -- 申请日期
            ,enable_date -- 启用日期
            ,pre_aud_nm -- 初审人
            ,confirm_nm -- 批准人
            ,protocal_id -- 协议编号
            ,sign_inst_id -- 签约机构代码(银联分配机构号)
            ,net_nm -- 隶属网点代码
            ,agr_br -- 签约网点
            ,net_tel -- 网点电话
            ,prol_date -- 签约日期
            ,prol_tlr -- 签约柜员
            ,close_date -- 撤消签约日期
            ,close_tlr -- 撤消签约柜员
            ,main_tlr -- 维护柜员
            ,check_tlr -- 复核柜员
            ,acq_inst_id -- 商户所属机构代码
            ,acq_bk_name -- 收单行名称
            ,bank_no -- 分行号
            ,mcht_secret -- 商户秘钥
            ,reserved -- 保留
            ,upd_opr_id -- 修改记录操作员
            ,crt_opr_id -- 创建记录操作员
            ,rec_upd_ts -- 记录修改时间
            ,rec_crt_ts -- 记录创建时间
            ,province_code -- 省份编码
            ,city_code -- 城市编码
            ,district_code -- 区域编码
            ,legal_person_id_card -- 法人证件号码
            ,flow_bank_no -- 流程银行流水号
            ,flow_bank_status -- 流程银行审批结果,0-初始状态1-审批通过2-审批不通过
            ,flow_bank_reserved -- 流程银行审批描述
            ,h5_flow_flag -- H5标识 ，1-H5渠道
            ,risk_statu -- 
            ,mq_statu -- 
            ,risk_describe -- 
            ,risk_flag -- 
            ,out_mcht_no -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_jh_mcht_inf_op(
            agent_cd -- 代理编号
            ,mcht_no -- 商户号
            ,mcht_nm -- 商户名称
            ,mcht_cn_abbr -- 中文名称简写
            ,spell_name -- 商户拼音缩写
            ,eng_name -- 商户英文名称
            ,mcht_en_abbr -- 商户英文名称缩写
            ,license_type -- 证件类型
            ,licence_no -- 证件编号号码
            ,licence_end_date -- 证件有效期
            ,mcht_lvl -- 商户级别
            ,contact -- 联系人姓名
            ,contact_class -- 联系人类型
            ,comm_email -- 联系人电子邮箱
            ,comm_mobil -- 客户电话
            ,comm_tel -- 联系人电话
            ,addr -- 联系人地址
            ,manager -- 法人姓名
            ,artif_certif_tp -- 法人证件类型
            ,identity_no -- 联系人证件号码
            ,manager_tel -- 法人联系电话
            ,post_code -- 邮编
            ,fax -- 传真
            ,area_no -- 区域代码
            ,mcht_eng_city_name -- 商户所在城市
            ,mcht_key -- 商户密钥
            ,oper_no -- 客户经理工号
            ,oper_nm -- 客户经理姓名
            ,mcht_status -- 商户状态
            ,risl_lvl -- 商户风险级别
            ,reg_addr -- 注册地址
            ,bank_licence_no -- 机构代码证号码
            ,bus_type -- 营业性质
            ,fax_no -- 税务登记证号码
            ,bus_amt -- 注册资金
            ,mcht_cre_lvl -- 企业资质等级
            ,apply_date -- 申请日期
            ,enable_date -- 启用日期
            ,pre_aud_nm -- 初审人
            ,confirm_nm -- 批准人
            ,protocal_id -- 协议编号
            ,sign_inst_id -- 签约机构代码(银联分配机构号)
            ,net_nm -- 隶属网点代码
            ,agr_br -- 签约网点
            ,net_tel -- 网点电话
            ,prol_date -- 签约日期
            ,prol_tlr -- 签约柜员
            ,close_date -- 撤消签约日期
            ,close_tlr -- 撤消签约柜员
            ,main_tlr -- 维护柜员
            ,check_tlr -- 复核柜员
            ,acq_inst_id -- 商户所属机构代码
            ,acq_bk_name -- 收单行名称
            ,bank_no -- 分行号
            ,mcht_secret -- 商户秘钥
            ,reserved -- 保留
            ,upd_opr_id -- 修改记录操作员
            ,crt_opr_id -- 创建记录操作员
            ,rec_upd_ts -- 记录修改时间
            ,rec_crt_ts -- 记录创建时间
            ,province_code -- 省份编码
            ,city_code -- 城市编码
            ,district_code -- 区域编码
            ,legal_person_id_card -- 法人证件号码
            ,flow_bank_no -- 流程银行流水号
            ,flow_bank_status -- 流程银行审批结果,0-初始状态1-审批通过2-审批不通过
            ,flow_bank_reserved -- 流程银行审批描述
            ,h5_flow_flag -- H5标识 ，1-H5渠道
            ,risk_statu -- 
            ,mq_statu -- 
            ,risk_describe -- 
            ,risk_flag -- 
            ,out_mcht_no -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agent_cd -- 代理编号
    ,o.mcht_no -- 商户号
    ,o.mcht_nm -- 商户名称
    ,o.mcht_cn_abbr -- 中文名称简写
    ,o.spell_name -- 商户拼音缩写
    ,o.eng_name -- 商户英文名称
    ,o.mcht_en_abbr -- 商户英文名称缩写
    ,o.license_type -- 证件类型
    ,o.licence_no -- 证件编号号码
    ,o.licence_end_date -- 证件有效期
    ,o.mcht_lvl -- 商户级别
    ,o.contact -- 联系人姓名
    ,o.contact_class -- 联系人类型
    ,o.comm_email -- 联系人电子邮箱
    ,o.comm_mobil -- 客户电话
    ,o.comm_tel -- 联系人电话
    ,o.addr -- 联系人地址
    ,o.manager -- 法人姓名
    ,o.artif_certif_tp -- 法人证件类型
    ,o.identity_no -- 联系人证件号码
    ,o.manager_tel -- 法人联系电话
    ,o.post_code -- 邮编
    ,o.fax -- 传真
    ,o.area_no -- 区域代码
    ,o.mcht_eng_city_name -- 商户所在城市
    ,o.mcht_key -- 商户密钥
    ,o.oper_no -- 客户经理工号
    ,o.oper_nm -- 客户经理姓名
    ,o.mcht_status -- 商户状态
    ,o.risl_lvl -- 商户风险级别
    ,o.reg_addr -- 注册地址
    ,o.bank_licence_no -- 机构代码证号码
    ,o.bus_type -- 营业性质
    ,o.fax_no -- 税务登记证号码
    ,o.bus_amt -- 注册资金
    ,o.mcht_cre_lvl -- 企业资质等级
    ,o.apply_date -- 申请日期
    ,o.enable_date -- 启用日期
    ,o.pre_aud_nm -- 初审人
    ,o.confirm_nm -- 批准人
    ,o.protocal_id -- 协议编号
    ,o.sign_inst_id -- 签约机构代码(银联分配机构号)
    ,o.net_nm -- 隶属网点代码
    ,o.agr_br -- 签约网点
    ,o.net_tel -- 网点电话
    ,o.prol_date -- 签约日期
    ,o.prol_tlr -- 签约柜员
    ,o.close_date -- 撤消签约日期
    ,o.close_tlr -- 撤消签约柜员
    ,o.main_tlr -- 维护柜员
    ,o.check_tlr -- 复核柜员
    ,o.acq_inst_id -- 商户所属机构代码
    ,o.acq_bk_name -- 收单行名称
    ,o.bank_no -- 分行号
    ,o.mcht_secret -- 商户秘钥
    ,o.reserved -- 保留
    ,o.upd_opr_id -- 修改记录操作员
    ,o.crt_opr_id -- 创建记录操作员
    ,o.rec_upd_ts -- 记录修改时间
    ,o.rec_crt_ts -- 记录创建时间
    ,o.province_code -- 省份编码
    ,o.city_code -- 城市编码
    ,o.district_code -- 区域编码
    ,o.legal_person_id_card -- 法人证件号码
    ,o.flow_bank_no -- 流程银行流水号
    ,o.flow_bank_status -- 流程银行审批结果,0-初始状态1-审批通过2-审批不通过
    ,o.flow_bank_reserved -- 流程银行审批描述
    ,o.h5_flow_flag -- H5标识 ，1-H5渠道
    ,o.risk_statu -- 
    ,o.mq_statu -- 
    ,o.risk_describe -- 
    ,o.risk_flag -- 
    ,o.out_mcht_no -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.mrms_tbl_jh_mcht_inf_bk o
    left join ${iol_schema}.mrms_tbl_jh_mcht_inf_op n
        on
            o.mcht_no = n.mcht_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_jh_mcht_inf_cl d
        on
            o.mcht_no = d.mcht_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_tbl_jh_mcht_inf;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_tbl_jh_mcht_inf') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_tbl_jh_mcht_inf drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_tbl_jh_mcht_inf add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_tbl_jh_mcht_inf exchange partition p_${batch_date} with table ${iol_schema}.mrms_tbl_jh_mcht_inf_cl;
alter table ${iol_schema}.mrms_tbl_jh_mcht_inf exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_jh_mcht_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_jh_mcht_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_jh_mcht_inf_op purge;
drop table ${iol_schema}.mrms_tbl_jh_mcht_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_jh_mcht_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_jh_mcht_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
