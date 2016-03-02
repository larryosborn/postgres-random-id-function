CREATE OR REPLACE FUNCTION random_id(tbl REGCLASS, len INTEGER) RETURNS CHARACTER VARYING AS $$

DECLARE

    is_unique BOOL := FALSE;
    chars TEXT[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
    id CHARACTER VARYING := '';
    i INTEGER := 0;

BEGIN

    IF len < 0 THEN
        RAISE EXCEPTION 'Given length cannot be less than 0';
    END IF;

    WHILE NOT is_unique LOOP

        id := '';

        FOR i IN 1..len LOOP
            id := id || chars[1 + RANDOM() * (ARRAY_LENGTH(chars, 1) - 1)];
        END LOOP;

        EXECUTE FORMAT('SELECT (NOT EXISTS (SELECT 1 FROM %s WHERE "id" = ''%s''))', tbl, id) INTO is_unique;

    END LOOP;

    RETURN id;

END
$$ LANGUAGE PLPGSQL VOLATILE;